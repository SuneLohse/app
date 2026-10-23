tableextension 70529 "ABA Batch Production Order Ext" extends "Production Order"
{
    fields
    {
        field(70525; "ABA Quantity per Batch"; Decimal)
        {
            Caption = 'Quantity per Batch';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                BatchProductionFunctions.CalculateQuantityPerBatch(Rec);
            end;
        }
        field(70526; "ABA how Many Batches"; Integer)
        {
            Caption = 'How many Batches';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                BatchProductionFunctions.CalculateQuantityPerBatch(Rec);
            end;
        }
    }

    var
        BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
}
