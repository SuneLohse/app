tableextension 70532 "ABA Prod. Order Routing Ext" extends "Prod. Order Routing Line"
{
    fields
    {
        field(70525; "ABA Output Qty to post"; Decimal)
        {
            Caption = 'Output Quantity to post';
            DataClassification = CustomerContent;
            Decimalplaces = 0 : 5;
        }
        field(70526; "ABA Setup Time to post"; Decimal)
        {
            Caption = 'Setup Time to post';
            DataClassification = CustomerContent;
            Decimalplaces = 0 : 5;
        }
        field(70527; "ABA Run Time to post"; Decimal)
        {
            Caption = 'Run Time to post';
            DataClassification = CustomerContent;
            Decimalplaces = 0 : 5;
        }
    }
}
