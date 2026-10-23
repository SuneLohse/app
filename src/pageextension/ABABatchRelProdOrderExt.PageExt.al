pageextension 70531 "ABA Batch Rel. Prod. Order Ext" extends "Released Production Order"
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
