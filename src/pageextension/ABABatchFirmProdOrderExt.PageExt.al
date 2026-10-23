pageextension 70533 "ABA Batch Firm Prod. Order Ext" extends "Firm Planned Prod. Order"
{
    layout
    {
        addbefore("Quantity")
        {
            field("ABA Quantity per Batch"; Rec."ABA Quantity per Batch")
            {
                ApplicationArea = All;
            }
            field("ABA how Many Batches"; Rec."ABA how Many Batches")
            {
                ApplicationArea = All;
            }
        }
    }
}
