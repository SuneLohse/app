table 70525 "ABA Batch Consumption Buffer"
{
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(2; "Source Type"; Code[20])
        {
            Caption = 'Source Type';
        }
        field(3; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(4; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(7; Percentage; Decimal)
        {
            Caption = 'Percentage';
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(PK; "Table No.", "Source Type", "Source No.", "Source Line No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
