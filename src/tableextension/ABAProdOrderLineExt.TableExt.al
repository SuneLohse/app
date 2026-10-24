tableextension 70530 "ABA Prod. Order Line Ext" extends "Prod. Order Line"
{
    fields
    {
        field(70525; "ABA Output Qty to post"; Decimal)
        {
            Caption = 'Output Quantity to post';
            DataClassification = CustomerContent;
            Decimalplaces = 0 : 5;
        }
        field(70530; "ABA Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;

            // trigger OnValidate()
            // begin
            //     BatchProductionFunctions.UpdateItemTrackingFromProdComp(Rec);
            // end;
        }
        field(70531; "ABA Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
            // trigger OnValidate()
            // begin
            //     BatchProductionFunctions.UpdateItemTrackingFromProdComp(Rec);
            // end;
        }
    }
}
