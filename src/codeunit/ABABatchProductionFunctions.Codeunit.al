codeunit 70525 "ABA Batch Production Functions"
{
    var
        MoreLinesExistsMsg: Label 'More';
    internal procedure CalculateConsumptionPercentage(var Buffer: Record "ABA Batch Consumption Buffer" temporary)
    var
        GroupBuffer: Record "ABA Batch Consumption Buffer" temporary;
        SumBuffer: Record "ABA Batch Consumption Buffer" temporary;
        GroupTotalQty: Decimal;
    begin
        GroupBuffer.Copy(Buffer, true);
        GroupBuffer.Reset();
        if GroupBuffer.FindSet() then
            repeat
                SumBuffer.Copy(Buffer, true);
                SumBuffer.SetRange("Table No.", GroupBuffer."Table No.");
                SumBuffer.SetRange("Source Type", GroupBuffer."Source Type");
                SumBuffer.SetRange("Source No.", GroupBuffer."Source No.");
                SumBuffer.SetRange("Source Line No.", GroupBuffer."Source Line No.");
                SumBuffer.CalcSums(Quantity);
                GroupTotalQty := SumBuffer.Quantity;

                Buffer := GroupBuffer;
                if GroupTotalQty <> 0 then
                    Buffer.Percentage := Round(Buffer.Quantity / GroupTotalQty * 100, 0.00001)
                else
                    Buffer.Percentage := 0;
                Buffer.Modify();
            until GroupBuffer.Next() = 0;
    end;

    internal procedure CalculateItemJournalPct(var Rec: Record "Item Journal Line"): Boolean
    var
        ItemJnlLine: Record "Item Journal Line";
        BatchConsumptionBuffer: Record "ABA Batch Consumption Buffer";
        BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
    begin
        if not GuiAllowed() then
            exit;
        //Skal vi lave kladderne "ikke temporære, og så slette dem man forlader dem?
        if Rec.IsTemporary() then
            exit;
        if Rec."Order Type" <> Rec."Order Type"::Production then
            exit;
        if Rec."Entry Type" <> Rec."Entry Type"::Consumption then
            exit;
        if (Rec."Order No." = '') or (Rec."Order Line No." = 0) then
            exit;
        ItemJnlLine.CopyFilters(Rec);
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        ItemJnlLine.SetRange("Order No.", Rec."Order No.");
        ItemJnlLine.SetRange("Order Line No.", Rec."Order Line No."); //This will equal Batch Number with Batch production, when using only one batch per Production Order Line.
        ItemJnlLine.SetRange("Entry Type", ItemJnlLine."Entry Type"::Consumption);
        //Vi skal lige teste om denne har opdateret til den nyeste værdi eller om den har fat i den gamle.
        If ItemJnlLine.FindSet() then
        repeat
            //Burde vi i stedet bare lave denne med et linjenummer som primærnøgle?
            BatchConsumptionBuffer."Table No." := database::"Item Journal Line";
            BatchConsumptionBuffer."Line No." := ItemJnlLine."Line No.";
            BatchConsumptionBuffer."Source Type" := 'ITEM JOURNAL';
            BatchConsumptionBuffer."Source No." := ItemJnlLine."Order No.";
            BatchConsumptionBuffer."Source Line No." := ItemJnlLine."Order Line No.";
            BatchConsumptionBuffer.Quantity := ItemJnlLine."Quantity (Base)";
            BatchConsumptionBuffer.Insert();
        until ItemJnlLine.Next() = 0;
        BatchProductionFunctions.CalculateConsumptionPercentage(BatchConsumptionBuffer);
        If ItemJnlLine.FindSet() then
        repeat
            if GetBatchConsumptionBuffer(database::"Item Journal Line", ItemJnlLine."Line No.", 'ITEM JOURNAL', ItemJnlLine."Order No.", ItemJnlLine."Order Line No.", BatchConsumptionBuffer) then begin
                ItemJnlLine."ABA Batch Production ConsPct." := BatchConsumptionBuffer.Percentage;
                ItemJnlLine.Modify();   
                if Rec."Line No." = ItemJnlLine."Line No." then
                    Rec."ABA Batch Production ConsPct." := BatchConsumptionBuffer.Percentage;
            end;    
        until ItemJnlLine.Next() = 0;
    end;

    internal procedure GetBatchConsumptionBuffer(TableNo: Integer; LineNo: Integer; SourceType: Text; DocumentNo: Text; DocumentLineNo: Integer; var BatchConsumptionBuffer: Record "ABA Batch Consumption Buffer"): Boolean
    begin
        BatchConsumptionBuffer.Setrange("Table No.", TableNo);
        BatchConsumptionBuffer.Setrange("Line No.", LineNo);
        BatchConsumptionBuffer.Setrange("Source Type", SourceType);
        BatchConsumptionBuffer.Setrange("Source No.", DocumentNo);
        BatchConsumptionBuffer.Setrange("Source Line No.", DocumentLineNo);
        if BatchConsumptionBuffer.FindFirst() then
            exit(true);
    end;

    internal procedure LookupLotOrSerialNoWithAvailability(ItemNo: Code[20]; VariantCode: Code[10]; LotOrSerialNo: Option LotNo,SerialNo; DefaultLotNo: Code[50]; DefaultSerialNo: Code[50]; LocationFilter: Text; RequiredQtyBase: Decimal; var SelectedLotNo: Code[50]; var SelectedSerialNo: Code[50]; var SelectedLocationCode: Code[10]; var SelectedQtyBase: Decimal)
    var
        Item: Record Item;
        ItemTrackingList: Record "ABA Item Tracking List" temporary;
        ItemTrackingListPage: Page "ABA Item Tracking List";
        HideLotNo: Boolean;
        HideSerialNo: Boolean;
    begin
        if not Item.Get(ItemNo) then begin
            Message('Item %1 not found.', ItemNo);
            exit;
        end;

        DetermineLotSerialTracking(Item, HideLotNo, HideSerialNo);
        BuildItemTrackingList(ItemNo, VariantCode, LocationFilter, LotOrSerialNo,ItemTrackingList);

        if ItemTrackingList.IsEmpty() then begin
            Message('No available tracking entries for this item.');
            exit;
        end;

        ItemTrackingListPage.SetPage(HideLotNo, HideSerialNo);
        ItemTrackingListPage.SetTempRecords(ItemTrackingList);
        ItemTrackingListPage.lookupMode(true);

        if ItemTrackingListPage.RunModal() = Action::LookupOK then begin
            ItemTrackingListPage.GetRecord(ItemTrackingList);
            SelectedLotNo := ItemTrackingList."Lot No.";
            SelectedSerialNo := ItemTrackingList."Serial No.";
            SelectedLocationCode := ItemTrackingList."Location Code";
            if ItemTrackingList."Remaining Qty. (Base)" > RequiredQtyBase then
                SelectedQtyBase := RequiredQtyBase
            else
                SelectedQtyBase := ItemTrackingList."Remaining Qty. (Base)";
        end;
    end;

    local procedure DetermineLotSerialTracking(Item: Record Item; var HideLotNo: Boolean; var HideSerialNo: Boolean)
    begin
        HideLotNo := not (Item."Lot Nos." <> '');
        HideSerialNo := not (Item."Serial Nos." <> '');
    end;

    local procedure BuildItemTrackingList(ItemNo: Code[20]; VariantCode: Code[10]; LocationFilter: Text; LotOrSerialNo: Option LotNo,SerialNo;var ItemTrackingList: Record "ABA Item Tracking List")
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        EntryNo: Integer;
    begin
        ItemTrackingList.DeleteAll();
        EntryNo := 0;

        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        if LocationFilter <> '' then
           ItemLedgerEntry.SetFilter("Location Code", LocationFilter);
        case LotOrSerialNo of
            LotOrSerialNo::LotNo:
                ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
            LotOrSerialNo::SerialNo:
                ItemLedgerEntry.SetFilter("Serial No.", '<>&'); 

        end;
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');

        if ItemLedgerEntry.FindSet() then
            repeat
                if not ItemTrackingListEntryExists(ItemTrackingList, ItemNo, VariantCode, ItemLedgerEntry."Lot No.", ItemLedgerEntry."Serial No.", ItemLedgerEntry."Location Code") then begin
                    EntryNo += 1;
                    ItemTrackingList.Init();
                    ItemTrackingList."Entry No." := EntryNo;
                    ItemTrackingList."Item No." := ItemNo;
                    ItemTrackingList."Variant Code" := VariantCode;
                    ItemTrackingList."Lot No." := ItemLedgerEntry."Lot No.";
                    ItemTrackingList."Serial No." := ItemLedgerEntry."Serial No.";
                    ItemTrackingList."Location Code" := ItemLedgerEntry."Location Code";
                    ItemTrackingList."Remaining Qty. (Base)" := GetAccumulatedRemainingQty(ItemNo, VariantCode, ItemLedgerEntry."Lot No.", ItemLedgerEntry."Serial No.", ItemLedgerEntry."Location Code");
                    ItemTrackingList."Expiration Date" := ItemLedgerEntry."Expiration Date";
                    ItemTrackingList.Insert();
                end;
            until ItemLedgerEntry.Next() = 0;
            ItemtrackingList.reset();
    end;

    local procedure ItemTrackingListEntryExists(var ItemTrackingList: Record "ABA Item Tracking List"; ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; SerialNo: Code[50]; LocationCode: Code[10]): Boolean
    begin
        ItemTrackingList.SetRange("Item No.", ItemNo);
        ItemTrackingList.SetRange("Variant Code", VariantCode);
        ItemTrackingList.SetRange("Lot No.", LotNo);
        ItemTrackingList.SetRange("Serial No.", SerialNo);
        ItemTrackingList.SetRange("Location Code", LocationCode);
        exit(ItemTrackingList.FindFirst());
    end;

    local procedure GetAccumulatedRemainingQty(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; SerialNo: Code[50]; LocationCode: Code[10]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Variant Code", VariantCode);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        ItemLedgerEntry.SetRange("Serial No.", SerialNo);
        ItemLedgerEntry.SetRange("Location Code", LocationCode);
        ItemLedgerEntry.CalcSums("Remaining Quantity");
        exit(ItemLedgerEntry."Remaining Quantity");
    end;


    internal procedure CalculateQuantityPerBatch(var ProductionOrder: Record "Production Order")
    begin
        if ProductionOrder."ABA how Many Batches" = 0 then
            exit;
        ProductionOrder."ABA Quantity per Batch" := ProductionOrder.Quantity / ProductionOrder."ABA how Many Batches";
    end;

    internal procedure UpdateItemTrackingFromProdComp(var ProdOrderComponent: Record "Prod. Order Component")
    begin
        DeleteItemTrackingLines(Database::"Prod. Order Component", ProdOrderComponent.Status.AsInteger(), ProdOrderComponent."Prod. Order No.", '', ProdOrderComponent."Line No.", ProdOrderComponent."Prod. Order Line No.");
        if ProdOrderComponent."ABA Lot No." = '' then
            exit;
        if ProdOrderComponent."Remaining Quantity" = 0 then
            exit;

        UpdateItemTrackingLines(Database::"Prod. Order Component", ProdOrderComponent.Status.AsInteger(), ProdOrderComponent."Prod. Order No.", '',
                                ProdOrderComponent."Prod. Order Line No.", ProdOrderComponent."Line No.", ProdOrderComponent."Item No.", ProdOrderComponent."Variant Code",
                                ProdOrderComponent."Location Code", ProdOrderComponent."ABA Lot No.", ProdOrderComponent."ABA Serial No.", -ProdOrderComponent."Remaining Qty. (Base)", -ProdOrderComponent."Remaining Qty. (Base)", -ProdOrderComponent."ABA Add Lot Qty", -ProdOrderComponent."ABA Add Serial Qty");
    end;
    internal procedure UpdateItemTrackingFromILL(var ItemJournalLine: Record "Item Journal Line")
    begin
        DeleteItemTrackingLines(Database::"Item Journal Line", 5, ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name", ItemJournalLine."Line No.", 0);
        if ItemJournalLine."ABA Lot No." = '' then
            exit;
        if ItemJournalLine."Quantity" = 0 then
            exit;

        UpdateItemTrackingLines(Database::"Item Journal Line", 5, ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name", 0, ItemJournalLine."Line No.",
                                ItemJournalLine."Item No.", ItemJournalLine."Variant Code",
                                ItemJournalLine."Location Code", ItemJournalLine."ABA Lot No.", ItemJournalLine."ABA Serial No.", -ItemJournalLine."Quantity", -ItemJournalLine."Quantity", -ItemJournalLine."ABA Add Lot Qty", -ItemJournalLine."ABA Add Serial Qty");
    end;

    internal procedure LookupSimpleItemTracking(LotNo: Code[50]; SerialNo: Code[50]; LotOrSerialNo: Option LotNo,SerialNo): Boolean
    begin
        case LotOrSerialNo of
            LotOrSerialNo::LotNo:
                exit(LotNo = '');
            LotOrSerialNo::SerialNo:
                exit(SerialNo = '');
        end;
    end;
    internal procedure GetItemTrackingLines(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; SourceProdOrderLine: Integer; var LotTrackingNo: Code[50]; var LotTotalQtyToHandleBase: Decimal; var SerialTrackingNo: Code[50]; var SerialTotalQtyToHandleBase: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
        RecordCount: Integer;
    begin
        LotTotalQtyToHandleBase := 0;
        LotTrackingNo := '';
        SerialTotalQtyToHandleBase := 0;
        SerialTrackingNo := '';
        RecordCount := 0;

        ReservEntry.SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, false);
        ReservEntry.SetRange("Source Prod. Order Line", SourceProdOrderLine);

        if ReservEntry.FindSet() then begin
            repeat
                if ReservEntry."Lot No." <> '' then
                    LotTotalQtyToHandleBase += ReservEntry."Qty. to Handle (Base)";
                if ReservEntry."Serial No." <> '' then
                    SerialTotalQtyToHandleBase += ReservEntry."Qty. to Handle (Base)";
                RecordCount += 1;
            until ReservEntry.Next() = 0;

            ReservEntry.FindFirst();
            if RecordCount = 1 then begin
                if ReservEntry."Lot No." <> '' then
                    LotTrackingNo := ReservEntry."Lot No.";
                if ReservEntry."Serial No." <> '' then
                    SerialTrackingNo := ReservEntry."Serial No.";
            end else begin
                if ReservEntry."Lot No." <> '' then
                    LotTrackingNo := MoreLinesExistsMsg;
                if ReservEntry."Serial No." <> '' then
                    SerialTrackingNo := MoreLinesExistsMsg;
            end;
        end;
    end;

    internal procedure UpdateItemTrackingLines(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdOrderLine: Integer; SourceRefNo: Integer; ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; LotNo: Code[50]; SerialNo: Code[50]; Quantity: Decimal; QuantityBase: Decimal;  LotQtyToHandleBase: Decimal; SerialQtyToHandleBase: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Init();
        ReservEntry."Entry No." := 0;
        ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Surplus;
        ReservEntry."Source Type" := SourceType;
        ReservEntry."Source Subtype" := SourceSubtype;
        ReservEntry."Source ID" := SourceID;
        ReservEntry."Source Batch Name" := SourceBatchName;
        ReservEntry."Source Prod. Order Line" := SourceProdOrderLine;
        ReservEntry."Source Ref. No." := SourceRefNo;
        ReservEntry."Item No." := ItemNo;
        ReservEntry."Variant Code" := VariantCode;
        ReservEntry."Location Code" := LocationCode;
        ReservEntry.Quantity := Quantity;
        if SerialQtyToHandleBase <> 0 then begin
            ReservEntry."Serial No." := SerialNo;
            ReservEntry."Quantity (Base)" := 1;
            ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";           
            if LotQtyToHandleBase <> 0 then begin
                ReservEntry."Lot No." := LotNo;
            end;
        end else
            if LotQtyToHandleBase <> 0 then begin
                ReservEntry."Lot No." := LotNo;
                ReservEntry."Quantity (Base)" := LotQtyToHandleBase;
                ReservEntry."Qty. to Handle (Base)" := ReservEntry."Quantity (Base)";
            end;        
        ReservEntry.Positive := ReservEntry.Quantity > 0;
        ReservEntry."Creation Date" := Today();
        ReservEntry.Insert(true);
    end;
    
    local procedure DeleteItemTrackingLines(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer; SourceProdOrderLine: Integer)
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.SetSourceFilter(SourceType, SourceSubtype, SourceID, SourceRefNo, false);
        ReservEntry."Source Batch Name" := SourceBatchName;
        ReservEntry.SetRange("Source Prod. Order Line", SourceProdOrderLine);
        ReservEntry.DeleteAll(true);
    end;

    internal procedure SplitProdOrderLine(var ProdOrderLine: Record "Prod. Order Line")
    var
        ProductionOrder: Record "Production Order";
        SplitProdOrderLine: Page "ABA Batch Split Prod. Line";
        NoOfLines: Integer;
    begin
        if ProdOrderLine.Status = ProdOrderLine.Status::Finished then
            exit;
        if ProductionOrder.Get(ProdOrderLine.Status, ProdOrderLine."Prod. Order No.") then
            SplitProdOrderLine.SetNoOfLines(ProductionOrder."ABA how Many Batches");
        if SplitProdOrderLine.RunModal() <> Action::OK then
            exit;
        NoOfLines := SplitProdOrderLine.GetNoOfLines();
        if NoOfLines < 2 then
            exit;
        DoSplitProdOrderLine(ProdOrderLine, NoOfLines);
    end;

    local procedure DoSplitProdOrderLine(var ProdOrderLine: Record "Prod. Order Line"; NoOfLines: Integer)
    var
        NewProdOrderLine: Record "Prod. Order Line";
        Item: Record Item;
        OriginalQty: Decimal;
        SplitQty: Decimal;
        RoundingPrecision: Decimal;
        NewLineNo: Integer;
        i: Integer;
    begin
        OriginalQty := ProdOrderLine.Quantity;

        RoundingPrecision := 0.00001;
        if Item.Get(ProdOrderLine."Item No.") and (Item."Rounding Precision" <> 0) then
            RoundingPrecision := Item."Rounding Precision";

        SplitQty := Round(OriginalQty / NoOfLines, RoundingPrecision, '<');

        for i := 1 to NoOfLines - 1 do begin
            NewProdOrderLine := ProdOrderLine;
            NewLineNo := GetNextProdOrderLineNo(ProdOrderLine);
            NewProdOrderLine."Line No." := NewLineNo;
            SetProdOrderLineQuantity(NewProdOrderLine, SplitQty);
            NewProdOrderLine.Insert(true);

            CopyProdOrderComponents(ProdOrderLine, NewProdOrderLine, OriginalQty);
            CopyProdOrderRoutingLines(ProdOrderLine, NewProdOrderLine, OriginalQty);
        end;

        SetProdOrderLineQuantity(ProdOrderLine, OriginalQty - SplitQty * (NoOfLines - 1));
        ProdOrderLine.Modify(true);

        UpdateProdOrderComponentQuantities(ProdOrderLine, OriginalQty);
        UpdateProdOrderRoutingLineQuantities(ProdOrderLine, OriginalQty);
    end;

    local procedure SetProdOrderLineQuantity(var ProdOrderLine: Record "Prod. Order Line"; NewQuantity: Decimal)
    begin
        ProdOrderLine.Quantity := NewQuantity;
        ProdOrderLine."Remaining Quantity" := NewQuantity - ProdOrderLine."Finished Quantity";
        ProdOrderLine."Quantity (Base)" := Round(NewQuantity * ProdOrderLine."Qty. per Unit of Measure", 0.00001);
        ProdOrderLine."Remaining Qty. (Base)" := Round(ProdOrderLine."Remaining Quantity" * ProdOrderLine."Qty. per Unit of Measure", 0.00001);
    end;

    local procedure GetNextProdOrderLineNo(ProdOrderLine: Record "Prod. Order Line"): Integer
    var
        LastProdOrderLine: Record "Prod. Order Line";
    begin
        LastProdOrderLine.SetRange(Status, ProdOrderLine.Status);
        LastProdOrderLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        if LastProdOrderLine.FindLast() then
            exit(LastProdOrderLine."Line No." + 10000);
        exit(10000);
    end;

    local procedure CopyProdOrderComponents(FromProdOrderLine: Record "Prod. Order Line"; ToProdOrderLine: Record "Prod. Order Line"; OriginalQty: Decimal)
    var
        FromProdOrderComponent: Record "Prod. Order Component";
        NewProdOrderComponent: Record "Prod. Order Component";
    begin
        FromProdOrderComponent.SetRange(Status, FromProdOrderLine.Status);
        FromProdOrderComponent.SetRange("Prod. Order No.", FromProdOrderLine."Prod. Order No.");
        FromProdOrderComponent.SetRange("Prod. Order Line No.", FromProdOrderLine."Line No.");
        if FromProdOrderComponent.FindSet() then
            repeat
                NewProdOrderComponent := FromProdOrderComponent;
                NewProdOrderComponent."Prod. Order Line No." := ToProdOrderLine."Line No.";
                ScaleProdOrderComponentQuantity(NewProdOrderComponent, ToProdOrderLine.Quantity, OriginalQty);
                NewProdOrderComponent.Insert(true);
                CopyItemTrackingLines(FromProdOrderComponent, NewProdOrderComponent, ToProdOrderLine.Quantity, OriginalQty);
            until FromProdOrderComponent.Next() = 0;
    end;

    local procedure UpdateProdOrderComponentQuantities(ProdOrderLine: Record "Prod. Order Line"; OriginalQty: Decimal)
    var
        ProdOrderComponent: Record "Prod. Order Component";
    begin
        ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        if ProdOrderComponent.FindSet() then
            repeat
                ScaleItemTrackingLines(ProdOrderComponent, ProdOrderLine.Quantity, OriginalQty);
                ScaleProdOrderComponentQuantity(ProdOrderComponent, ProdOrderLine.Quantity, OriginalQty);
                ProdOrderComponent.Modify(true);
            until ProdOrderComponent.Next() = 0;
    end;

    local procedure ScaleProdOrderComponentQuantity(var ProdOrderComponent: Record "Prod. Order Component"; NewQty: Decimal; OriginalQty: Decimal)
    begin
        if OriginalQty = 0 then
            exit;
        ProdOrderComponent."Expected Quantity" := Round(ProdOrderComponent."Expected Quantity" * NewQty / OriginalQty, 0.00001);
        ProdOrderComponent."Expected Qty. (Base)" := Round(ProdOrderComponent."Expected Qty. (Base)" * NewQty / OriginalQty, 0.00001);
        ProdOrderComponent."Remaining Quantity" := Round(ProdOrderComponent."Remaining Quantity" * NewQty / OriginalQty, 0.00001);
        ProdOrderComponent."Remaining Qty. (Base)" := Round(ProdOrderComponent."Remaining Qty. (Base)" * NewQty / OriginalQty, 0.00001);
        ProdOrderComponent."Quantity (Base)" := Round(ProdOrderComponent."Quantity (Base)" * NewQty / OriginalQty, 0.00001);
        ProdOrderComponent."Pick Qty. (Base)" := Round(ProdOrderComponent."Pick Qty. (Base)" * NewQty / OriginalQty, 0.00001);
    end;

    local procedure CopyItemTrackingLines(FromProdOrderComponent: Record "Prod. Order Component"; ToProdOrderComponent: Record "Prod. Order Component"; NewQty: Decimal; OriginalQty: Decimal)
    var
        FromReservEntry: Record "Reservation Entry";
        NewReservEntry: Record "Reservation Entry";
    begin
        if OriginalQty = 0 then
            exit;

        FromReservEntry.SetSourceFilter(Database::"Prod. Order Component", FromProdOrderComponent.Status.AsInteger(), FromProdOrderComponent."Prod. Order No.", FromProdOrderComponent."Line No.", false);
        FromReservEntry.SetRange("Source Prod. Order Line", FromProdOrderComponent."Prod. Order Line No.");
        if not FromReservEntry.FindSet() then
            exit;

        repeat
            NewReservEntry := FromReservEntry;
            NewReservEntry."Entry No." := 0;
            NewReservEntry."Source Prod. Order Line" := ToProdOrderComponent."Prod. Order Line No.";
            NewReservEntry.Quantity := Round(FromReservEntry.Quantity * NewQty / OriginalQty, 0.00001);
            NewReservEntry."Quantity (Base)" := Round(FromReservEntry."Quantity (Base)" * NewQty / OriginalQty, 0.00001);
            NewReservEntry."Qty. to Handle (Base)" := Round(FromReservEntry."Qty. to Handle (Base)" * NewQty / OriginalQty, 0.00001);
            NewReservEntry."Qty. to Invoice (Base)" := Round(FromReservEntry."Qty. to Invoice (Base)" * NewQty / OriginalQty, 0.00001);
            NewReservEntry.Insert(true);
        until FromReservEntry.Next() = 0;
    end;

    local procedure ScaleItemTrackingLines(ProdOrderComponent: Record "Prod. Order Component"; NewQty: Decimal; OriginalQty: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
    begin
        if OriginalQty = 0 then
            exit;

        ReservEntry.SetSourceFilter(Database::"Prod. Order Component", ProdOrderComponent.Status.AsInteger(), ProdOrderComponent."Prod. Order No.", ProdOrderComponent."Line No.", false);
        ReservEntry.SetRange("Source Prod. Order Line", ProdOrderComponent."Prod. Order Line No.");
        if ReservEntry.FindSet() then
            repeat
                ReservEntry.Quantity := Round(ReservEntry.Quantity * NewQty / OriginalQty, 0.00001);
                ReservEntry."Quantity (Base)" := Round(ReservEntry."Quantity (Base)" * NewQty / OriginalQty, 0.00001);
                ReservEntry."Qty. to Handle (Base)" := Round(ReservEntry."Qty. to Handle (Base)" * NewQty / OriginalQty, 0.00001);
                ReservEntry."Qty. to Invoice (Base)" := Round(ReservEntry."Qty. to Invoice (Base)" * NewQty / OriginalQty, 0.00001);
                ReservEntry.Modify(true);
            until ReservEntry.Next() = 0;
    end;

    local procedure CopyProdOrderRoutingLines(FromProdOrderLine: Record "Prod. Order Line"; var ToProdOrderLine: Record "Prod. Order Line"; OriginalQty: Decimal)
    var
        FromProdOrderRoutingLine: Record "Prod. Order Routing Line";
        NewProdOrderRoutingLine: Record "Prod. Order Routing Line";
        NewRoutingReferenceNo: Integer;
    begin
        if FromProdOrderLine."Routing Reference No." = 0 then
            exit;

        FromProdOrderRoutingLine.SetRange(Status, FromProdOrderLine.Status);
        FromProdOrderRoutingLine.SetRange("Prod. Order No.", FromProdOrderLine."Prod. Order No.");
        FromProdOrderRoutingLine.SetRange("Routing Reference No.", FromProdOrderLine."Routing Reference No.");
        if not FromProdOrderRoutingLine.FindSet() then
            exit;

        NewRoutingReferenceNo := GetNextRoutingReferenceNo(FromProdOrderLine);
        repeat
            NewProdOrderRoutingLine := FromProdOrderRoutingLine;
            NewProdOrderRoutingLine."Routing Reference No." := NewRoutingReferenceNo;
            ScaleRunTime(NewProdOrderRoutingLine, ToProdOrderLine.Quantity, OriginalQty);
            NewProdOrderRoutingLine.Insert(true);
        until FromProdOrderRoutingLine.Next() = 0;

        ToProdOrderLine."Routing Reference No." := NewRoutingReferenceNo;
        ToProdOrderLine.Modify(true);
    end;

    local procedure UpdateProdOrderRoutingLineQuantities(ProdOrderLine: Record "Prod. Order Line"; OriginalQty: Decimal)
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        if ProdOrderLine."Routing Reference No." = 0 then
            exit;

        ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        if ProdOrderRoutingLine.FindSet() then
            repeat
                ScaleRunTime(ProdOrderRoutingLine, ProdOrderLine.Quantity, OriginalQty);
                ProdOrderRoutingLine.Modify(true);
            until ProdOrderRoutingLine.Next() = 0;
    end;

    local procedure GetNextRoutingReferenceNo(ProdOrderLine: Record "Prod. Order Line"): Integer
    var
        LastProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        LastProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        LastProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        if LastProdOrderRoutingLine.FindLast() then
            exit(LastProdOrderRoutingLine."Routing Reference No." + 1);
        exit(1);
    end;

    local procedure ScaleRunTime(var ProdOrderRoutingLine: Record "Prod. Order Routing Line"; NewQty: Decimal; OriginalQty: Decimal)
    begin
        if OriginalQty = 0 then
            exit;
        ProdOrderRoutingLine."Run Time" := Round(ProdOrderRoutingLine."Run Time" * NewQty / OriginalQty, 0.00001);
    end;
    internal procedure PrepareProdOrderCompMatrix(var ProdOrderLine: Record "Prod. Order Line")
    var
        InformationMatrixRec: Record "SCB New Information Matrix";
        InformationMatrixPage: Page "SCB Information Matrix";
    begin
        //SetTypeCU.SetConfigType(ActionType);
        FillInProdOrderCompMatrix(5407, ProdOrderLine);
        // InformationMatrixRec.SetRange(Table, 5407);
        // InformationMatrixRec.SetRange(KeyField1, format(ProdOrderLine.Status));
        // InformationMatrixRec.SetRange(KeyField2, format(ProdOrderLine."Prod. Order No."));
        // InformationMatrixRec.SetRange(KeyField3, format(ProdOrderLine."Line No."));
        // InformationMatrixPage.SetTableView(InformationMatrixRec);
        // //InformationMatrixPage.SetPageView2('', ActionType);
        // InformationMatrixPage.Run();
    end;
    internal procedure FillInProdOrderCompMatrix(TableNo: Integer; ProdOrderLine: Record "Prod. Order Line")
    var
        AddMatriceLines: Record "SCB Add Matrice Lines";
        AddMatriceLinesFilters: Record "SCB Add Matrice Lines Filters";
        InformationMatrixRec: Record "SCB New Information Matrix";
        ProdOrderComponent: record "Prod. order component";
        SetTypeCU: Codeunit "SCB SetTypeCodeUnit";
        InfoMatrixSetup: Record "SCB New Info Matrix Setup";
        InformationMatrixPage: Page "SCB Information Matrix";
        CompExistErr: Label 'There is no Componentens related to the Production Order Line';
        RecordsHandled: Integer;
        AddOrRemove: Option Add,Remove;
    begin
        InformationMatrixRec.SetRange("User ID", CopyStr(UpperCase(UserId), 1, MaxStrLen(AddMatriceLines."User ID")));;
        InformationMatrixRec.SetRange(Table, TableNo);
        InformationMatrixRec.SetRange(KeyField1, format(ProdOrderLine.Status));
        InformationMatrixRec.SetRange(KeyField2, format(ProdOrderLine."Prod. Order No."));
        InformationMatrixRec.SetRange(KeyField3, format(ProdOrderLine."Line No."));
        if InformationMatrixRec.FindSet() then
            InformationMatrixRec.DeleteAll();
        ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        // if ProdOrderComponent.FindSet() then
        //     repeat
        //         InformationMatrixRec.Init();
        //         InformationMatrixRec.Table := 5407;
        //         InformationMatrixRec.KeyField1 := format(ProdOrderLine.Status);
        //         InformationMatrixRec.KeyField2 := format(ProdOrderLine."Prod. Order No.");
        //         InformationMatrixRec.KeyField3 := format(ProdOrderLine."Line No.");
        //         InformationMatrixRec.KeyField4 := format(ProdOrderComponent."Line No."

        //SLO 2024-04-05 We could consider making this function obsolete, since the parameter ActionType is found in the function,
        //and therefore should not be part of the parameters.
        if not ProdOrderComponent.FindFirst() then
            Error(CompExistErr);
        InfoMatrixSetup.Get('PRODORDERCOMP'); //Skal rettes
        // InformationMatrixRec.SetRange("User ID", UpperCase(UserId));
        // InformationMatrixRec.SetRange(Table, 5407);
        // InformationMatrixRec.DeleteAll();
        AddMatriceLines."User ID" := CopyStr(UpperCase(UserId), 1, MaxStrLen(AddMatriceLines."User ID"));
        AddMatriceLines.Table := TableNo;
        AddMatriceLinesFilters.SetRange("User ID", CopyStr(UpperCase(UserId), 1, MaxStrLen(AddMatriceLines."User ID")));
        AddMatriceLinesFilters.SetRange(Table, TableNo);
        AddMatriceLinesFilters.DeleteAll();
        AddMatriceLinesFilters."User ID" := CopyStr(UpperCase(UserId), 1, MaxStrLen(AddMatriceLinesFilters."User ID"));
        AddMatriceLinesFilters.Table := TableNo;
        AddMatriceLinesFilters."Field Name" := 'Status';
        AddMatriceLinesFilters."Field Filter" := format(ProdOrderLine.Status);
        AddMatriceLinesFilters.Insert();
        AddMatriceLinesFilters."Field Name" := 'Prod. Order No.';
        AddMatriceLinesFilters."Field Filter" := format(ProdOrderLine."Prod. Order No.");
        AddMatriceLinesFilters.Insert();
        AddMatriceLinesFilters."Field Name" := 'Prod. Order Line No.';
        AddMatriceLinesFilters."Field Filter" := format(ProdOrderLine."Line No.");
        AddMatriceLinesFilters.Insert();
        AddMatriceLines.AddOrRemoveMatriceLines2(AddMatriceLines, AddOrRemove::Add, RecordsHandled);
        SetTypeCU.SetConfigType(tableNo);
        InformationMatrixPage.SetTableView(InformationMatrixRec);
        InformationMatrixPage.SetPageView2('', TableNo);
        InformationMatrixPage.Run();
    end;

    internal procedure AddLotOrSerialNo(ItemNo: Code[20]; VariantCode: Code[20]; var LotNo: Code[20]; var SerialNo: Code[20]; LocationCode: Code[10]; LotOrSerialNo: Option LotNo,SerialNo; RequiredQtyBase: Decimal; var AddLotQty: Decimal; var AddSerialQty: Decimal)
        var
            BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
            SelectedLotNo: Code[50];
            SelectedSerialNo: Code[50];
            SelectedLocationCode: Code[10];
            SelectedQtyBase: Decimal;
        begin
                SelectedLotNo := LotNo;
                SelectedSerialNo := SerialNo;
                SelectedLocationCode := LocationCode;
                SelectedQtyBase := 0;

                BatchProductionFunctions.LookupLotOrSerialNoWithAvailability(
                    ItemNo,
                    VariantCode,
                    LotOrSerialNo,
                    SelectedLotNo,
                    SelectedSerialNo,
                    LocationCode,
                    RequiredQtyBase,
                    SelectedLotNo,
                    SelectedSerialNo,
                    SelectedLocationCode,
                    SelectedQtyBase);

                case LotOrSerialNo of
                    LotOrSerialNo::LotNo:
                        if SelectedLotNo <> '' then begin
                            LotNo := SelectedLotNo;
                            AddLotQty := SelectedQtyBase;
                            AddSerialQty := 0;
                        end;
                    LotOrSerialNo::SerialNo:
                        if SelectedSerialNo <> '' then begin
                            SerialNo := SelectedSerialNo;
                            AddLotQty := SelectedQtyBase;
                            AddSerialQty := 0;
                        end;
                end;
        end;
}
