pageextension 70536 "ABA Prod. Order Routing Ext" extends "Prod. Order Routing"
{
    layout
    {
        addbefore("Setup Time")
        {
            field("ABA Output Qty to post"; Rec."ABA Output Qty to post")
            {
                ApplicationArea = All;
            }
        }
        addafter("Setup Time")
        {
            field("ABA Setup Time to post"; Rec."ABA Setup Time to post")
            {
                ApplicationArea = All;
            }
        }
        addafter("Run Time")
        {
            field("ABA Run Time to post"; Rec."ABA Run Time to post")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}
