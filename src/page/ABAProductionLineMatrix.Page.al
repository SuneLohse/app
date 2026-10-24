#pragma implicitwith disable
page 70525 "ABA Production Line Matrix"
{
    PageType = ListPart;
    Caption = 'Production Line';
    SourceTable = "SCB New Information Matrix";
    SourceTableView = SORTING("User ID", Table, "No.");
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Table)
                {
                    ApplicationArea = All;
                    Visible = false;
                    Caption = 'Table';
                    ToolTip = 'Specifies the value of the Table field.';

                    trigger OnValidate()
                    begin
                        if Rec.Table <> GlobalType then
                            Error(SCB672Text001, GlobalType);
                    end;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Item Variant Code"; ItemVariantRemove)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies the value of the ItemVariantRemove field.';
                }
                field(KeyField1; Rec.KeyField1)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption1;
                    Editable = false;
                    Visible = ShowKey1;
                    ToolTip = 'Specifies the value of the Key Field 1 field.';
                }
                field(KeyField2; Rec.KeyField2)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption2;
                    Editable = false;
                    Visible = ShowKey2;
                    ToolTip = 'Specifies the value of the Key Field 2 field.';
                }
                field(KeyField3; Rec.KeyField3)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption3;
                    Editable = false;
                    Visible = ShowKey3;
                    ToolTip = 'Specifies the value of the Key Field 3 field.';
                }
                field(KeyField4; Rec.KeyField4)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption4;
                    Editable = false;
                    Visible = ShowKey4;
                    ToolTip = 'Specifies the value of the Key Field 4 field.';
                }
                field(KeyField5; Rec.KeyField5)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption5;
                    Editable = false;
                    Visible = ShowKey5;
                    ToolTip = 'Specifies the value of the Key Field 5 field.';
                }
                field(KeyField6; Rec.KeyField6)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption6;
                    Editable = false;
                    Visible = ShowKey6;
                    ToolTip = 'Specifies the value of the Key Field 6 field.';
                }
                field(KeyField7; Rec.KeyField7)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption7;
                    Editable = false;
                    Visible = ShowKey7;
                    ToolTip = 'Specifies the value of the Key Field 7 field.';
                }
                field(KeyField8; Rec.KeyField8)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption8;
                    Editable = false;
                    Visible = ShowKey8;
                    ToolTip = 'Specifies the value of the Key Field 8 field.';
                }
                field(KeyField9; Rec.KeyField9)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption9;
                    Editable = false;
                    Visible = ShowKey9;
                    ToolTip = 'Specifies the value of the Key Field 9 field.';
                }
                field(KeyField10; Rec.KeyField10)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + KeyCaption10;
                    Editable = false;
                    Visible = ShowKey10;
                    ToolTip = 'Specifies the value of the Key Field 10 field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Special Sorting No."; Rec."Special Sorting No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Special Sorting No. field.';
                }
                field(Column1; Rec.Column1)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption1;
                    Visible = Visible1;
                    ToolTip = 'Specifies the value of the Column1 field.';
                }
                field(Column2; Rec.Column2)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption2;
                    Visible = Visible2;
                    ToolTip = 'Specifies the value of the Column2 field.';
                }
                field(Column3; Rec.Column3)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption3;
                    Visible = Visible3;
                    ToolTip = 'Specifies the value of the Column3 field.';
                }
                field(Column4; Rec.Column4)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption4;
                    Visible = Visible4;
                    ToolTip = 'Specifies the value of the Column4 field.';
                }
                field(Column5; Rec.Column5)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption5;
                    Visible = Visible5;
                    ToolTip = 'Specifies the value of the Column5 field.';
                }
                field(Column6; Rec.Column6)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption6;
                    Visible = Visible6;
                    ToolTip = 'Specifies the value of the Column6 field.';
                }
                field(Column7; Rec.Column7)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption7;
                    Visible = Visible7;
                    ToolTip = 'Specifies the value of the Column7 field.';
                }
                field(Column8; Rec.Column8)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption8;
                    Visible = Visible8;
                    ToolTip = 'Specifies the value of the Column8 field.';
                }
                field(Column9; Rec.Column9)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption9;
                    Visible = Visible9;
                    ToolTip = 'Specifies the value of the Column9 field.';
                }
                field(Column10; Rec.Column10)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption10;
                    Visible = Visible10;
                    ToolTip = 'Specifies the value of the Column10 field.';
                }
                field(Column11; Rec.Column11)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption11;
                    Visible = Visible11;
                    ToolTip = 'Specifies the value of the Column11 field.';
                }
                field(Column12; Rec.Column12)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption12;
                    Visible = Visible12;
                    ToolTip = 'Specifies the value of the Column12 field.';
                }
                field(Column13; Rec.Column13)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption13;
                    Visible = Visible13;
                    ToolTip = 'Specifies the value of the Column13 field.';
                }
                field(Column14; Rec.Column14)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption14;
                    Visible = Visible14;
                    ToolTip = 'Specifies the value of the Column14 field.';
                }
                field(Column15; Rec.Column15)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,5,,' + Caption15;
                    Visible = Visible15;
                    ToolTip = 'Specifies the value of the Column15 field.';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Table <> GlobalType then
            Error(SCB672Text001, GlobalType);
    end;

    trigger OnOpenPage()
    begin
        GlobalType := Database::"Prod. Order Line";
        KeyCount := SCBBasicFunctions.CountPrimaryKeys(GlobalType);
        SCBBasicFunctions.SetVisibleKeys(KeyCount, ShowKey1, ShowKey2, ShowKey3, ShowKey4, ShowKey5, ShowKey6, ShowKey7, ShowKey8, ShowKey9, ShowKey10);
        ShowKey1 := false;
        ShowKey2 := false;
        ShowKey3 := false;
        ShowKey4 := false;
        ShowKey5 := false;
        RefreshPage();

        if GlobalSortingField <> '' then
            Rec.SetCurrentKey("Special Sorting No.");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.GetFilter("No.") <> '' then
            Rec."No." := Rec.GetRangeMax("No.");
    end;

    var
        SCBBasicFunctions: Codeunit "SCB Basic Functions";
        AttributFunctions: Codeunit "SCB Information Functions";
        ItemVariantRemove: Boolean;
        ShowKey1: Boolean;
        ShowKey2: Boolean;
        ShowKey3: Boolean;
        ShowKey4: Boolean;
        ShowKey5: Boolean;
        ShowKey6: Boolean;
        ShowKey7: Boolean;
        ShowKey8: Boolean;
        ShowKey9: Boolean;
        ShowKey10: Boolean;
        Visible1: Boolean;
        Visible2: Boolean;
        Visible3: Boolean;
        Visible4: Boolean;
        Visible5: Boolean;
        Visible6: Boolean;
        Visible7: Boolean;
        Visible8: Boolean;
        Visible9: Boolean;
        Visible10: Boolean;
        Visible11: Boolean;
        Visible12: Boolean;
        Visible13: Boolean;
        Visible14: Boolean;
        Visible15: Boolean;
        GlobalSetupCode: Code[30];
        GlobalType: Integer;
        KeyCount: Integer;
        SCB672Text001: Label 'Type must be %1';
        Caption1: Text;
        Caption2: Text;
        Caption3: Text;
        Caption4: Text;
        Caption5: Text;
        Caption6: Text;
        Caption7: Text;
        Caption8: Text;
        Caption9: Text;
        Caption10: Text;
        Caption11: Text;
        Caption12: Text;
        Caption13: Text;
        Caption14: Text;
        Caption15: Text;
        KeyCaption1: Text;
        KeyCaption2: Text;
        KeyCaption3: Text;
        KeyCaption4: Text;
        KeyCaption5: Text;
        KeyCaption6: Text;
        KeyCaption7: Text;
        KeyCaption8: Text;
        KeyCaption9: Text;
        KeyCaption10: Text;
        GlobalSortingField: Text[50];

    procedure SetPageView2(GlobalSetupCodeVar: Code[30]; GlobalTypeVar: Integer)
    var
        AttributeMatrixSetup: Record "SCB New Info Matrix Setup";
        AttributeUserSetup: Record "SCB New Information User Setup";
    begin
        GlobalSetupCode := GlobalSetupCodeVar;
        GlobalType := GlobalTypeVar;
        if GlobalSetupCode = '' then begin
            if not AttributeUserSetup.Get(UpperCase(UserId), GlobalType) then begin
                AttributeMatrixSetup.SetRange(Table, GlobalType);
                if AttributeMatrixSetup.FindFirst() then begin
                    AttributeUserSetup."User ID" := UpperCase(UserId);
                    AttributeUserSetup.Table := GlobalType;
                    AttributeUserSetup.Code := AttributeMatrixSetup.Code;
                    AttributeUserSetup."Special Sorting Field" := GlobalSortingField;
                    AttributeUserSetup.Insert();
                    GlobalSetupCode := AttributeUserSetup.Code;
                end;
            end else begin
                GlobalSetupCode := AttributeUserSetup.Code;
                GlobalSortingField := AttributeUserSetup."Special Sorting Field";
            end;
        end;
    end;

    procedure BuildPageColumns()
    begin
        Error('Replaced by BuildPageColumns2');
    end;

    procedure BuildPageColumns2()
    var
        AttributeMatrixSetup: Record "SCB New Info Matrix Setup";
    begin
        Visible1 := true;
        Visible2 := true;
        Visible3 := true;
        Visible4 := true;
        Visible5 := true;
        Visible6 := true;
        Visible7 := true;
        Visible8 := true;
        Visible9 := true;
        Visible10 := true;
        Visible11 := true;
        Visible12 := true;
        Visible13 := true;
        Visible14 := true;
        Visible15 := true;

        if GlobalSetupCode <> '' then
            if AttributeMatrixSetup.Get(GlobalSetupCode) then begin
                if AttributeMatrixSetup."Column 1 Table Field" = '' then
                    Visible1 := false;
                if AttributeMatrixSetup."Column 2 Table Field" = '' then
                    Visible2 := false;
                if AttributeMatrixSetup."Column 3 Table Field" = '' then
                    Visible3 := false;
                if AttributeMatrixSetup."Column 4 Table Field" = '' then
                    Visible4 := false;
                if AttributeMatrixSetup."Column 5 Table Field" = '' then
                    Visible5 := false;
                if AttributeMatrixSetup."Column 6 Table Field" = '' then
                    Visible6 := false;
                if AttributeMatrixSetup."Column 7 Table Field" = '' then
                    Visible7 := false;
                if AttributeMatrixSetup."Column 8 Table Field" = '' then
                    Visible8 := false;
                if AttributeMatrixSetup."Column 9 Table Field" = '' then
                    Visible9 := false;
                if AttributeMatrixSetup."Column 10 Table Field" = '' then
                    Visible10 := false;
                if AttributeMatrixSetup."Column 11 Table Field" = '' then
                    Visible11 := false;
                if AttributeMatrixSetup."Column 12 Table Field" = '' then
                    Visible12 := false;
                if AttributeMatrixSetup."Column 13 Table Field" = '' then
                    Visible13 := false;
                if AttributeMatrixSetup."Column 14 Table Field" = '' then
                    Visible14 := false;
                if AttributeMatrixSetup."Column 15 Table Field" = '' then
                    Visible15 := false;
            end;
    end;

    procedure RefreshPage()
    var
        MDISupportFunctions: codeunit "ABA MDI Support Functions";
    begin
        SetPageView2(GlobalSetupCode, GlobalType);
        AttributFunctions.BuildMatrixViewNew(GlobalType);
        BuildPageColumns2();
        Rec.SetRange("User ID", UpperCase(UserId));
        Rec.SetRange(Table, GlobalType);
        Caption1 := AttributFunctions.ConfCaptionClassTranslate('1', GlobalType);
        Caption2 := AttributFunctions.ConfCaptionClassTranslate('2', GlobalType);
        Caption3 := AttributFunctions.ConfCaptionClassTranslate('3', GlobalType);
        Caption4 := AttributFunctions.ConfCaptionClassTranslate('4', GlobalType);
        Caption5 := AttributFunctions.ConfCaptionClassTranslate('5', GlobalType);
        Caption6 := AttributFunctions.ConfCaptionClassTranslate('6', GlobalType);
        Caption7 := AttributFunctions.ConfCaptionClassTranslate('7', GlobalType);
        Caption8 := AttributFunctions.ConfCaptionClassTranslate('8', GlobalType);
        Caption9 := AttributFunctions.ConfCaptionClassTranslate('9', GlobalType);
        Caption10 := AttributFunctions.ConfCaptionClassTranslate('10', GlobalType);
        Caption11 := AttributFunctions.ConfCaptionClassTranslate('11', GlobalType);
        Caption12 := AttributFunctions.ConfCaptionClassTranslate('12', GlobalType);
        Caption13 := AttributFunctions.ConfCaptionClassTranslate('13', GlobalType);
        Caption14 := AttributFunctions.ConfCaptionClassTranslate('14', GlobalType);
        Caption15 := AttributFunctions.ConfCaptionClassTranslate('15', GlobalType);
        MDISupportFunctions.RemoveTypeFromCaption(Caption1, Caption2, Caption3, Caption4, Caption5, Caption6, Caption7, Caption8, Caption9, Caption10, Caption11, Caption12, Caption13, Caption14, Caption15);
        SCBBasicFunctions.GetPrimaryKeyFieldNamesFromTableNo(GlobalType, KeyCaption1, KeyCaption2, KeyCaption3, KeyCaption4, KeyCaption5, KeyCaption6, KeyCaption7, KeyCaption8, KeyCaption9, KeyCaption10);
    end;
    
    local procedure ValidateGlobalSortingField()
    var
        AttributeMatrixSetup: Record "SCB New Info Matrix Setup";
        InfoCode: Record "SCB New Information Code";
        AttributeUserSetup: Record "SCB New Information User Setup";
    begin
        AttributeMatrixSetup.Get(GlobalSetupCode);
        if GlobalSortingField <> '' then begin
            InfoCode.SetRange(Code, GlobalSortingField);
            InfoCode.SetFilter(Table, '%1|%2', GlobalType, 0);
            InfoCode.SetRange(Subtype, InfoCode.Subtype::Specification);
            InfoCode.SetFilter("Validation Datatype", '%1|%2|%3|%4|%5',
               InfoCode."Validation Datatype"::Decimal, InfoCode."Validation Datatype"::Integer,
               InfoCode."Validation Datatype"::Boolean, InfoCode."Validation Datatype"::Date, InfoCode."Validation Datatype"::DateTime);
            InfoCode.FindFirst();
        end;

        AttributeUserSetup."User ID" := UpperCase(UserId);
        AttributeUserSetup.Table := GlobalType;
        AttributeUserSetup.Code := AttributeMatrixSetup.Code;
        AttributeUserSetup."Special Sorting Field" := GlobalSortingField;
        if not AttributeUserSetup.Insert() then
            AttributeUserSetup.Modify();
        SetPageView2('', GlobalType);
        RefreshPage();
        CurrPage.Update(false);
    end;
}
