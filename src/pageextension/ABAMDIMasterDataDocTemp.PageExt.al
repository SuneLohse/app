pageextension 70527 "ABA MDI Master Data Doc Temp" extends "SCB Master Data on Doc. Templ."
{
    layout
    {
        addlast(Group)
        {
            field("ABA Batch Production Transfer to Journal Line"; Rec."ABA Batch Production Journal")
            {
                ApplicationArea = All;
            }
            field("ABA Batch Production Transfer to Lot and Serial Numbers"; Rec."ABA Batch Production LotSerial")
            {
                ApplicationArea = All;
            }
        }
    }
}
