tableextension 70526 "ABA MDI Item Journal Line" extends "Item Journal Line"
{
    fields
    {
    field(70501; "SCB MDI Field 1"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,1';
            Caption = 'Master Data Information Field 1';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 1 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 1'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 1"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(83, 'SCB MDI Field 1', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 1", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70502; "SCB MDI Field 2"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,2';
            Caption = 'Master Data Information Field 2';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 2 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 2'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 2"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(83, 'SCB MDI Field 2', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 2", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70503; "SCB MDI Field 3"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,3';
            Caption = 'Master Data Information Field 3';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 3 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 3'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 3"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(83, 'SCB MDI Field 3', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 3", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70504; "SCB MDI Field 4"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,4';
            Caption = 'Master Data Information Field 4';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 4 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 4'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 4"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(83, 'SCB MDI Field 4', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 4", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70505; "SCB MDI Field 5"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,5';
            Caption = 'Master Data Information Field 5';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 5 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 5'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 5"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(83, 'SCB MDI Field 5', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 5", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70506; "SCB MDI Field 6"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,6';
            Caption = 'Master Data Information Field 6';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 6 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 6'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 6"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(Database::"Item Journal Line", 'SCB MDI Field 6', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 6", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70507; "SCB MDI Field 7"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,7';
            Caption = 'Master Data Information Field 7';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 7 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 7'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 7"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(Database::"Item Journal Line", 'SCB MDI Field 7', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 7", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70508; "SCB MDI Field 8"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,8';
            Caption = 'Master Data Information Field 8';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 8 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 8'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 8"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(Database::"Item Journal Line", 'SCB MDI Field 8', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 8", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70509; "SCB MDI Field 9"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,9';
            Caption = 'Master Data Information Field 9';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 9 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 9'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 9"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(Database::"Item Journal Line", 'SCB MDI Field 9', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 9", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70510; "SCB MDI Field 10"; Text[250])
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,10';
            Caption = 'Master Data Information Field 10';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 10 ';
            ValidateTableRelation = false;
            TableRelation = "SCB Information Value Lookup"."Information Value" where(
                    "Table No" = const(Database::"Item Journal Line"),
                    "Field Name" = const('SCB MDI Field 10'),
                    "Record SystemId" = field(SystemId),
                    "Master Data Table Type Text" = const('Master Data on Documents'),
                    "Information Value Code" = field("SCB MDI Field 10"));

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField_Text250(Database::"Item Journal Line", 'SCB MDI Field 10', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 10", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70511; "SCB MDI Field 11"; Date)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,11';
            Caption = 'Master Data Information Field 11';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 11 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 11', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 11", false) then
                    Validate("SCB MDI Field 11");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 11', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 11", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70512; "SCB MDI Field 12"; Date)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,12';
            Caption = 'Master Data Information Field 12';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 12 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 12', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 12", false) then
                    Validate("SCB MDI Field 12");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 12', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 12", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70513; "SCB MDI Field 13"; Date)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,13';
            Caption = 'Master Data Information Field 13';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 13 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 13', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 13", false) then
                    Validate("SCB MDI Field 13");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 13', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 13", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70514; "SCB MDI Field 14"; Decimal)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,14';
            Caption = 'Master Data Information Field 14';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 14 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 14', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 14", false) then
                    Validate("SCB MDI Field 14");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 14', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 14", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70515; "SCB MDI Field 15"; Decimal)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,15';
            Caption = 'Master Data Information Field 15';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 15 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 15', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 15", false) then
                    Validate("SCB MDI Field 15");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 15', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 15", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70516; "SCB MDI Field 16"; Decimal)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,16';
            Caption = 'Master Data Information Field 16';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            BlankZero = true;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 16 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 16', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 16", false) then
                    Validate("SCB MDI Field 16");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 16', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 16", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70517; "SCB MDI Field 17"; Integer)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,17';
            Caption = 'Master Data Information Field 17';
            DataClassification = CustomerContent;
            BlankZero = true;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 17 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 17', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 17", false) then
                    Validate("SCB MDI Field 17");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 17', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 17", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70518; "SCB MDI Field 18"; DateFormula)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,18';
            Caption = 'Master Data Information Field 18';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 18 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 18', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 18", false) then
                    Validate("SCB MDI Field 18");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 18', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 18", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70519; "SCB MDI Field 19"; DateTime)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,19';
            Caption = 'Master Data Information Field 19';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 19 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 19', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 19", false) then
                    Validate("SCB MDI Field 19");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 19', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 19", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70520; "SCB MDI Field 20"; Boolean)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,20';
            Caption = 'Master Data Information Field 20';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 20 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 20', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 20", false) then
                    Validate("SCB MDI Field 20");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 20', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 20", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70521; "SCB MDI Field 21"; Boolean)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,21';
            Caption = 'Master Data Information Field 21';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 21 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 21', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 21", false) then
                    Validate("SCB MDI Field 21");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 21', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 21", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70522; "SCB MDI Field 22"; Boolean)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,22';
            Caption = 'Master Data Information Field 22';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 22 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 22', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 22", false) then
                    Validate("SCB MDI Field 22");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 22', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 22", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70523; "SCB MDI Field 23"; Boolean)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,23';
            Caption = 'Master Data Information Field 23';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 23 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 23', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 23", false) then
                    Validate("SCB MDI Field 23");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 23', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 23", false);
                Rec.Get(Rec.RecordId());
            end;
        }
        field(70524; "SCB MDI Field 24"; Boolean)
        {
            CaptionClass = 'SCB_MDI_SpecOnPages,83,24';
            Caption = 'Master Data Information Field 24';
            DataClassification = CustomerContent;
            ToolTip = 'Shows value of the Specification - configured for Master Data Information field 24 ';
            trigger OnLookup()
            begin
                if ReplicateMDIFunction.LookupReplicateField(Database::"Item Journal Line", 'SCB MDI Field 24', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 24", false) then
                    Validate("SCB MDI Field 24");
            end;

            trigger OnValidate()
            begin
                Rec.Modify();
                ReplicateMDIFunction.ValidateReplicateField(Database::"Item Journal Line", 'SCB MDI Field 24', RecordId, 'Master Data on Documents', '', '', ' ', "SCB MDI Field 24", false);
                Rec.Get(Rec.RecordId());
            end;
        }

    }

    var
        ReplicateMDIFunction: Codeunit "SCB Replicate MDI Function";
}
