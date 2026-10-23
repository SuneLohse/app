tableextension 70528 "ABA MDI Master Data Doc Cont" extends "SCB New Master Data DocContent"
{
    fields
    {
        field(70001; "ABA Batch Production Journal"; Boolean)
        {
            Caption = 'Transfer to Production Journals';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether Master Data on Documents should be transferred to the Production Journal Lines when creating a Batch Production Journal.';
        }
        field(70002; "ABA Batch Production LotSerial"; Boolean)
        {
            Caption = 'Transfer to Lot and Serial Numbers';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether Master Data on Documents should be transferred to the Lot and Serial Numbers created when posting the Batch Production Journal.';
        }
    }
}
