codeunit 70527 "ABA MDI Support Functions"
{
    // The "Master Data on Document" logic that creates "SCB MDI On Documents" rows (GetMasterDataTemplate,
    // InsertMasterDataOnDocContentLine, ...) lives as `internal` procedures in codeunit "SCB Subscriber Events 682"
    // (app "Master Data Information") and cannot be called from this app. This resolves the template and creates the
    // content the same way, using only the public procedure `InsertMasterData` and the public template/setup tables,
    // then removes any content line not flagged "ABA Batch Production Journal" - mirroring how the base app already
    // filters "Transfer to Prod. Order Line"/"Transfer to Purchase Line" on "SCB New Master Data DocContent".

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure OnAfterValidateItemNoTransferItemMasterData(var Rec: Record "Item Journal Line"; xRec: Record "Item Journal Line")
    begin
        TransferItemMasterDataToItemJournalLine(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertTransferItemMasterData(var Rec: Record "Item Journal Line"; RunTrigger: Boolean)
    begin
        if not RunTrigger then
            exit;
        TransferItemMasterDataToItemJournalLine(Rec, Rec);
    end;

    var
        InformationUserSetup: Record "SCB New Information User Setup";
        SCBBasicFunctions: Codeunit "SCB Basic Functions";
        InformationFunctions: Codeunit "SCB Information Functions";
        SubscriberEvents: Codeunit "SCB Subscriber Events 682";
        Window: Dialog;

    /// <summary>
    /// Transfers Master Data on Documents content from the Item onto the Item Journal Line, the same way it is
    /// transferred onto Sales/Purchase lines, keeping only content lines flagged "ABA Batch Production Journal".
    /// Only runs interactively (GuiAllowed), matching that Master Data Information should only be created while a
    /// user is actually working in the journal, never during background/API/import processing.
    /// </summary>
    /// <param name="ItemJournalLine">The Item Journal Line receiving the master data. May be modified.</param>
    /// <param name="xItemJournalLine">The previous state of the Item Journal Line, used to detect an Item No. change.</param>
    procedure TransferItemMasterDataToItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; xItemJournalLine: Record "Item Journal Line")
    var
        MasterDataDocTemplate: Record "SCB Master Data Doc. Template";
        MasterDataonReportCarrier: Record "SCB Master Data on Doc.Carrier";
        DeleteTypeVar: Option Header,Line,Footer,HeaderAndFooter,"Item Tracking";
        InsertTypeVar: Option Header,Line,Footer;
        KeyField1: Code[20];
        KeyField2: Code[20];
        KeyField3: Code[20];
        KeyField4: Code[20];
        KeyField5: Code[20];
        CarryFromKeyField1: Code[20];
        CarryFromKeyField2: Code[20];
        CarryFromKeyField3: Code[20];
        CarryFromKeyField4: Code[20];
        CarryFromKeyField5: Code[20];
    begin
        if not GuiAllowed() then
            exit;
        if ItemJournalLine.IsTemporary() then
            exit;
        if ItemJournalLine."Order Type" <> ItemJournalLine."Order Type"::Production then
            exit;
        if ((ItemJournalLine."Order No." = '') or (ItemJournalLine."Order Line No." = 0) or (ItemJournalLine."Line No." = 0)) then
            exit;

        KeyField1 := 'TABLE ' + Format(Database::"Item Journal Line");
        KeyField2 := ItemJournalLine."Journal Template Name"; //GetProdOrderKeyField2(ItemJournalLine."Order No.");
        KeyField3 := ItemJournalLine."Journal Batch Name"; //ItemJournalLine."Order No.";
        KeyField4 := Format(ItemJournalLine."Line No.");

        CarryFromKeyField1 := 'TABLE ' + Format(Database::"Prod. Order Component");
        CarryFromKeyField2 := 'RELEASED';
        CarryFromKeyField3 := ItemJournalLine."Order No.";
        CarryFromKeyField4 := format(itemJournalLine."Order Line No.");
        CarryFromKeyField5 := format(itemJournalLine."Prod. Order Comp. Line No.");;

        if (xItemJournalLine."Item No." <> ItemJournalLine."Item No.") and (xItemJournalLine."Item No." <> '') then
            SubscriberEvents.DeleteMasterDataOnDocuments(KeyField1, KeyField2, KeyField3, KeyField4, '', 0, DeleteTypeVar::Line);

        if ItemJournalLine."Item No." = '' then
            exit;
        if not GetMasterDataDocTemplate(MasterDataDocTemplate, ItemJournalLine."Item No.") then
            exit;
        if MasterDataDocTemplate."Master Data Line" = '' then
            exit;


        //2026-09-28 SLO Test denne her.
        // SubscriberEvents.InsertMasterDataOnDocContentLine(RecRef, xRecRef, 0, Rec."Document Type".AsInteger(), Rec."Document No.", Rec."No.", Rec."Line No.", Rec."Sell-to Customer No.", SalesHeader."Language Code", RecRef.SystemIdNo())
        // RecRef := Rec = SalesLine
        // xRecRef := xRec
        // xRecRef
        // Rec := Sales Line
        // No. := Item No.

        InsertMasterDataonReportCarrier(MasterDataonReportCarrier, '', MasterDataonReportCarrier.Type::Line, ItemJournalLine."Item No.", '', MasterDataDocTemplate."Master Data Doc Template", KeyField1, KeyField2, KeyField3, KeyField4, KeyField5,carryFromKeyField1, CarryFromKeyField2, CarryFromKeyField3, CarryFromKeyField4, CarryFromKeyField5);
        
        InsertMasterData(MasterDataonReportCarrier, 
            MasterDataDocTemplate."Master Data Doc Template", InsertTypeVar::Line, ItemJournalLine."Item No.", '',
            MasterDataDocTemplate."Master Data Line", KeyField1, KeyField2, KeyField3, KeyField4, '');

        // InsertMasterData(
        //         MasterDataDocumentTemplate."Master Data Doc Template", TypeVar::Line, NoLine, LanguageCode,
        //         MasterDataDocumentTemplate."Master Data Line", GetTableNoAsText(RecRef), OptionValue, DocumentNo, Format(LineNo), '');

        RemoveContentNotFlaggedForJournal(MasterDataDocTemplate."Master Data Line", KeyField1, KeyField2, KeyField3, KeyField4);
    end;

    /// <summary>
    /// Resolves the "SCB Master Data Doc. Template" set up for Production, preferring an Item-specific setup row and
    /// falling back to the generic one - the same resolution "GetMasterDataTemplate" does internally in the base app.
    /// The Setup table forces "Document Type" to "Production Order" whenever "Type" is Production, so that is the
    /// only Document Type a Production setup row can ever have.
    /// </summary>
    /// <param name="MasterDataDocTemplate">Returns the resolved template when found.</param>
    /// <param name="ItemNo">The item number used for the item-specific setup lookup.</param>
    /// <returns>True when a template was resolved.</returns>
    local procedure GetMasterDataDocTemplate(var MasterDataDocTemplate: Record "SCB Master Data Doc. Template"; ItemNo: Code[20]): Boolean
    var
        MasterDataDocSetup: Record "SCB Master Data on Doc. Setup";
    begin
        if MasterDataDocSetup.Get(MasterDataDocSetup.Type::Production, MasterDataDocSetup."Document Type"::"Production Order", 'ItemNo') then
            exit(MasterDataDocTemplate.Get(MasterDataDocSetup."Master Data Doc Template"));
        if MasterDataDocSetup.Get(MasterDataDocSetup.Type::Production, MasterDataDocSetup."Document Type"::"Production Order", '') then
            exit(MasterDataDocTemplate.Get(MasterDataDocSetup."Master Data Doc Template"));
        exit(false);
    end;

    /// <summary>
    /// Deletes any "SCB MDI On Documents" row just created for this key that its originating template content line
    /// (matched by Template Code + Information Code, the same join the base app uses for posting-action lookups)
    /// does not have "ABA Batch Production Journal" set on.
    /// </summary>
    local procedure RemoveContentNotFlaggedForJournal(TemplateLineCode: Code[50]; KeyField1: Code[20]; KeyField2: Code[20]; KeyField3: Code[20]; KeyField4: Code[20])
    var
        MasterDataOnDocuments: Record "SCB MDI On Documents";
        MasterDataDocContent: Record "SCB New Master Data DocContent";
    begin
        MasterDataOnDocuments.SetRange("Key Field 1", KeyField1);
        MasterDataOnDocuments.SetRange("Key Field 2", KeyField2);
        MasterDataOnDocuments.SetRange("Key Field 3", KeyField3);
        MasterDataOnDocuments.SetRange("Key Field 4", KeyField4);
        MasterDataOnDocuments.SetRange("Key Field 5", '');
        MasterDataOnDocuments.SetRange(Type, MasterDataOnDocuments.Type::Line);
        if not MasterDataOnDocuments.FindSet() then
            exit;
        repeat
            MasterDataDocContent.SetRange("Template Code", CopyStr(TemplateLineCode, 1, MaxStrLen(MasterDataDocContent."Template Code")));
            MasterDataDocContent.SetRange("Information Code", MasterDataOnDocuments."Information Code");
            if not (MasterDataDocContent.FindFirst() and MasterDataDocContent."ABA Batch Production Journal") then
                MasterDataOnDocuments.Delete();
        until MasterDataOnDocuments.Next() = 0;
    end;

    local procedure GetProdOrderKeyField2(ProdOrderNo: Code[20]): Code[20]
    var
        ProductionOrder: Record "Production Order";
    begin
        if ProductionOrder.Get(ProductionOrder.Status::Released, ProdOrderNo) then
            exit('RELEASED');
        if ProductionOrder.Get(ProductionOrder.Status::"Firm Planned", ProdOrderNo) then
            exit('FIRM PLANNED');
        exit('PRODUCTION');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure OnAfterInsertItemLedgEntryTransferLotSerialMasterData(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    begin
        TransferMasterDataToLotSerialInformation(ItemLedgerEntry, ItemJournalLine);
    end;

    /// <summary>
    /// When posting a Production Item Journal Line creates a Consumption Item Ledger Entry with a Lot No. or Serial No.,
    /// transfers every Master Data on Documents content line flagged "ABA Batch Production LotSerial" on the Production
    /// template onto the Lot No. Information/Serial No. Information card as a real "SCB Information Entry" - i.e. it
    /// switches the specification from a Master Data on Document (tied to the now-posted journal line) to a permanent
    /// Information Entry (tied to the Lot/Serial No. Information record).
    /// </summary>
    /// <param name="ItemLedgerEntry">The just-inserted Consumption Item Ledger Entry.</param>
    /// <param name="ItemJournalLine">The Item Journal Line that was posted to create the entry.</param>
    procedure TransferMasterDataToLotSerialInformation(ItemLedgerEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line")
    var
        MasterDataDocTemplate: Record "SCB Master Data Doc. Template";
        MasterDataOnDocuments: Record "SCB MDI On Documents";
        MasterDataDocContent: Record "SCB New Master Data DocContent";
        MasterTableNo: Integer;
        MasterRecordId: RecordId;
    begin
        if ItemJournalLine."Order Type" <> ItemJournalLine."Order Type"::Production then
            exit;
        if ItemLedgerEntry."Entry Type" <> ItemLedgerEntry."Entry Type"::Consumption then
            exit;
        if (ItemLedgerEntry."Lot No." = '') and (ItemLedgerEntry."Serial No." = '') then
            exit;
        if not GetMasterDataDocTemplate(MasterDataDocTemplate, ItemJournalLine."Item No.") then
            exit;
        if not GetOrCreateLotSerialInformation(ItemLedgerEntry, MasterTableNo, MasterRecordId) then
            exit;

        MasterDataOnDocuments.SetRange("Key Field 1", 'TABLE ' + Format(Database::"Item Journal Line"));
        MasterDataOnDocuments.SetRange("Key Field 2", ItemJournalLine."Journal Template Name");
        MasterDataOnDocuments.SetRange("Key Field 3", ItemJournalLine."Journal Batch Name");
        MasterDataOnDocuments.SetRange("Key Field 4", Format(ItemJournalLine."Line No."));
        MasterDataOnDocuments.SetRange("Key Field 5", '');
        MasterDataOnDocuments.SetRange(Type, MasterDataOnDocuments.Type::Line);
        if not MasterDataOnDocuments.FindSet() then
            exit;
        repeat
            MasterDataDocContent.SetRange("Template Code", CopyStr(MasterDataDocTemplate."Master Data Line", 1, MaxStrLen(MasterDataDocContent."Template Code")));
            MasterDataDocContent.SetRange("Information Code", MasterDataOnDocuments."Information Code");
            if MasterDataDocContent.FindFirst() and MasterDataDocContent."ABA Batch Production LotSerial" then
                TransferContentToInformationEntry(MasterTableNo, MasterRecordId, ItemLedgerEntry, MasterDataOnDocuments);
        until MasterDataOnDocuments.Next() = 0;
    end;

    /// <summary>
    /// Resolves the Lot No. Information/Serial No. Information record matching the Item Ledger Entry's tracking,
    /// creating it if it does not exist yet, and returns its table ID and RecordId for use as the "SCB Information
    /// Entry" key. Prefers Lot No. when both happen to be set.
    /// </summary>
    local procedure GetOrCreateLotSerialInformation(ItemLedgerEntry: Record "Item Ledger Entry"; var MasterTableNo: Integer; var MasterRecordId: RecordId): Boolean
    var
        LotNoInformation: Record "Lot No. Information";
        SerialNoInformation: Record "Serial No. Information";
    begin
        if ItemLedgerEntry."Lot No." <> '' then begin
            if not LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
                LotNoInformation.Init();
                LotNoInformation."Item No." := ItemLedgerEntry."Item No.";
                LotNoInformation."Variant Code" := ItemLedgerEntry."Variant Code";
                LotNoInformation."Lot No." := ItemLedgerEntry."Lot No.";
                LotNoInformation.Insert(true);
            end;
            MasterTableNo := Database::"Lot No. Information";
            MasterRecordId := LotNoInformation.RecordId();
            exit(true);
        end;
        if ItemLedgerEntry."Serial No." <> '' then begin
            if not SerialNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Serial No.") then begin
                SerialNoInformation.Init();
                SerialNoInformation."Item No." := ItemLedgerEntry."Item No.";
                SerialNoInformation."Variant Code" := ItemLedgerEntry."Variant Code";
                SerialNoInformation."Serial No." := ItemLedgerEntry."Serial No.";
                SerialNoInformation.Insert(true);
            end;
            MasterTableNo := Database::"Serial No. Information";
            MasterRecordId := SerialNoInformation.RecordId();
            exit(true);
        end;
        exit(false);
    end;

    /// <summary>
    /// Creates or updates the "SCB Information Entry" for the given master record from a Master Data on Documents
    /// content line, copying every typed value field and stamping the source as the posted Item Ledger Entry.
    /// </summary>
    local procedure TransferContentToInformationEntry(MasterTableNo: Integer; MasterRecordId: RecordId; ItemLedgerEntry: Record "Item Ledger Entry"; MasterDataOnDocuments: Record "SCB MDI On Documents")
    var
        InformationEntry: Record "SCB Information Entry";
    begin
        InformationEntry.SetRange(Table, MasterTableNo);
        InformationEntry.SetRange("No.", MasterRecordId);
        InformationEntry.SetRange("Information Code", MasterDataOnDocuments."Information Code");
        InformationEntry.SetRange("Information Value", MasterDataOnDocuments."Information Value");
        if not InformationEntry.FindFirst() then begin
            InformationEntry.Init();
            InformationEntry.Table := MasterTableNo;
            InformationEntry."No." := MasterRecordId;
            InformationEntry."Information Code" := MasterDataOnDocuments."Information Code";
            InformationEntry."Information Value" := MasterDataOnDocuments."Information Value";
            InformationEntry."From Table" := Database::"Item Ledger Entry";
            InformationEntry."From No." := Format(ItemLedgerEntry."Entry No.");
            InformationEntry.Insert(true);
        end;
        InformationEntry.Value := MasterDataOnDocuments.Value;
        InformationEntry."Value Date" := MasterDataOnDocuments."Value Date";
        InformationEntry."Value DateFormula" := MasterDataOnDocuments."Value DateFormula";
        InformationEntry."Value DateTime" := MasterDataOnDocuments."Value DateTime";
        InformationEntry."Value Boolean" := MasterDataOnDocuments."Value Boolean";
        InformationEntry."Value Integer" := MasterDataOnDocuments."Value Integer";
        InformationEntry."Value Decimal" := MasterDataOnDocuments."Value Decimal";
        InformationEntry.Description := MasterDataOnDocuments.Description;
        InformationEntry.Modify(true);
    end;

    //2026-09-28 SLO Temp >>
    internal procedure InsertMasterDataonReportCarrier(var MasterDataonReportCarrier: Record "SCB Master Data on Doc.Carrier"; TemplateCode: Code[50]; TypeVar: Option Header,Line,Footer; "No.": Code[50]; LanguageCode: Code[10]; MasterDataTemplateCode: Code[50]; KeyField1: Code[50]; KeyField2: Code[20]; KeyField3: Code[20]; KeyField4: Code[20]; KeyField5: Code[20]; CarryFromKeyField1: Code[50]; CarryFromKeyField2: Code[20]; CarryFromKeyField3: Code[20]; CarryFromKeyField4: Code[20]; CarryFromKeyField5: Code[20])
    begin
        MasterDataonReportCarrier."User ID" := GetUserIdSessionIdValue(MasterDataonReportCarrier);
        MasterDataonReportCarrier."Key Field 1" := KeyField1;
        MasterDataonReportCarrier."Key Field 2" := KeyField2;
        MasterDataonReportCarrier."Key Field 3" := KeyField3;
        MasterDataonReportCarrier."Key Field 4" := KeyField4;
        MasterDataonReportCarrier."Key Field 5" := KeyField5;

        //2026-09-28 SLO New >>
        MasterDataonReportCarrier."Carry from Key Field 1" := CarryFromKeyField1;
        MasterDataonReportCarrier."Carry from Key Field 2" := CarryFromKeyField2;
        MasterDataonReportCarrier."Carry from Key Field 3" := CarryFromKeyField3;
        MasterDataonReportCarrier."Carry from Key Field 4" := CarryFromKeyField4;
        MasterDataonReportCarrier."Carry from Key Field 5" := CarryFromKeyField5;
        //2026-09-28 SLO New <<

        MasterDataonReportCarrier."Add more Lines" := false;
        MasterDataonReportCarrier."Key Field 5" := KeyField5;

        MasterDataonReportCarrier."Dont delete components" := false;
        MasterDataonReportCarrier."Template Code" := TemplateCode;
        MasterDataonReportCarrier.Type := TypeVar;
        MasterDataonReportCarrier."No." := "No.";
        MasterDataonReportCarrier."Language Code" := LanguageCode;
        MasterDataonReportCarrier."Master Data Template Code" := MasterDataTemplateCode;

        if not MasterDataonReportCarrier.Insert() then
            MasterDataonReportCarrier.Modify();
    end;
    internal procedure GetUserIdSessionIdValue(MasterDataonReportCarrier: Record "SCB Master Data on Doc.Carrier"): Code[50]
    var
        UniqueText: Text;
    begin
        UniqueText := Format(Abs(SessionId()));
        exit(CopyStr(
                StrSubstNo(
                    '%1;%2',
                    CopyStr(UpperCase(UserId), 1, MaxStrLen(MasterDataonReportCarrier."User ID") - 11),
                    UniqueText),
                1, MaxStrLen(MasterDataonReportCarrier."User ID")));
    end;

    local procedure InsertMasterData(var MasterDataonReportCarrier: Record "SCB Master Data on Doc.Carrier"; TemplateCode: Code[50]; TypeVar: Option Header,Line,Footer; "No.": Code[50]; LanguageCode: Code[10]; MasterDataTemplateCode: Code[50]; KeyField1: Code[50]; KeyField2: Code[20]; KeyField3: Code[20]; KeyField4: Code[20]; KeyField5: Code[20])
    var
        FieldTable: Record "Field";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        FieldName: Text[250];
    begin
        FieldName := 'InsertMasterDataInformation';
        FieldTable.SetRange(TableNo, 6083286);
        FieldTable.SetRange(FieldName, FieldName);
        if FieldTable.FindFirst() then begin
            RecRef.Open(6083286);
            FieldRef := RecRef.Field(FieldTable."No.");
            FieldRef.Validate(true);
        end
    end;
    //2026-09-28 SLO Temp <<

    internal procedure RemoveTypeFromCaption(var Caption1: Text; var Caption2: Text; var Caption3: Text; var Caption4: Text; var Caption5: Text; var Caption6: Text; var Caption7: Text; var Caption8: Text; var Caption9: Text; var Caption10: Text; var Caption11: Text; var Caption12: Text; var Caption13: Text; var Caption14: Text; var Caption15: Text)
    begin
        Caption1 := RemoveParentesAndContent(Caption1);
        Caption2 := RemoveParentesAndContent(Caption2);
        Caption3 := RemoveParentesAndContent(Caption3);
        Caption4 := RemoveParentesAndContent(Caption4);
        Caption5 := RemoveParentesAndContent(Caption5);
        Caption6 := RemoveParentesAndContent(Caption6);
        Caption7 := RemoveParentesAndContent(Caption7);
        Caption8 := RemoveParentesAndContent(Caption8);
        Caption9 := RemoveParentesAndContent(Caption9);
        Caption10 := RemoveParentesAndContent(Caption10);
        Caption11 := RemoveParentesAndContent(Caption11);
        Caption12 := RemoveParentesAndContent(Caption12);
        Caption13 := RemoveParentesAndContent(Caption13);
        Caption14 := RemoveParentesAndContent(Caption14);
        Caption15 := RemoveParentesAndContent(Caption15);
    end;

    internal procedure RemoveParentesAndContent(var TextToRemove: Text): Text
    begin
        if StrPos(TextToRemove, '(') > 0 then
            TextToRemove := CopyStr(TextToRemove, 1, StrPos(TextToRemove, '(') - 1);
        exit(TextToRemove);
    end;
}
