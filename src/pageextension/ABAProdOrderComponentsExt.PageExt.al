pageextension 70535 "ABA Prod. Order Components Ext" extends "Prod. Order Components"
{
    layout
    {
        addafter("Remaining Quantity")
        {
            field("ABA Quantity to post"; Rec."ABA Quantity to post")
            {
                ApplicationArea = All;
            }
            field("ABA Lot No."; Rec."ABA Lot No.")
            {
                ApplicationArea = All;

                trigger OnAssistEdit()
                begin
                    Rec.AddLotOrSerialNo(LotOrSerialNo::LotNo);
                end;
            }
            field("ABA Tracked Lot Qty"; Rec."ABA Tracked Lot Qty")
            {
                ApplicationArea = All;
            }
            field("ABA Serial No."; Rec."ABA Serial No.")
            {
                ApplicationArea = All;

                trigger OnAssistEdit()
                begin
                    Rec.AddLotOrSerialNo(LotOrSerialNo::SerialNo);
                end;
            }
        }
    }
    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Rec.GetItemTrackingLines();
    end;

    var
        LotOrSerialNo: Option LotNo,SerialNo;
}
