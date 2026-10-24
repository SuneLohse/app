tableextension 70533 "ABA Shop Floor Setup" extends "SCB Shop Floor Setup"
{
    fields
    {
        field(70525; "ABA Prod Line Info. Matrix"; code[30])
        {
            Caption = 'Production Line Information Matrix';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Production Line Information Matrix to be used for the Production Line on the Shop Floor Journal.';
            TableRelation = "SCB New Info Matrix Setup" where(
                    "Table" = const(Database::"Prod. Order Line"));
        }
        field(70526; "ABA Component Info. Matrix"; code[30])
        {
            Caption = 'Component Information Matrix';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Component Information Matrix to be used for the Component Lines on the Shop Floor Journal.';
            TableRelation = "SCB New Info Matrix Setup" where(
                    "Table" = const(Database::"Prod. Order Component"));
        }
        field(70527; "ABA Routing Info. Matrix"; code[30])
        {
            Caption = 'Routing Information Matrix';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the Routing Information Matrix to be used for the Routing Lines on the Shop Floor Journal.';
            TableRelation = "SCB New Info Matrix Setup" where(
                    "Table" = const(Database::"Prod. Order Routing Line"));
        }
    }
}
