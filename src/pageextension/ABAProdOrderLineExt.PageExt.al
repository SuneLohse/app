pageextension 70534 "ABA Prod. Order Line Ext" extends "Firm Planned Prod. Order Lines"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field("ABA Output Qty to post"; Rec."ABA Output Qty to post")
            {
                ApplicationArea = All;
            }
            field("ABA Lot No."; Rec."ABA Lot No.")
            {
                ApplicationArea = All;

                // trigger OnAssistEdit()
                // begin
                //     Rec.AddLotOrSerialNo(LotOrSerialNo::LotNo);
                // end;
            }
            // field("ABA Tracked Lot Qty"; Rec."ABA Tracked Lot Qty")
            // {
            //     ApplicationArea = All;
            // }
            field("ABA Serial No."; Rec."ABA Serial No.")
            {
                ApplicationArea = All;

                // trigger OnAssistEdit()
                // begin
                //     Rec.AddLotOrSerialNo(LotOrSerialNo::SerialNo);
                // end;
            }
        }
    }
    actions
    {
    }

    // trigger OnAfterGetRecord()
    // begin
    //     Rec.GetItemTrackingLines();
    // end;

    var
        LotOrSerialNo: Option LotNo,SerialNo;
}
