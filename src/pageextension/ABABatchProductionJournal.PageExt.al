pageextension 70525 "ABA Batch Production Journal" extends "Production Journal"
{
    layout
    {
        addbefore(Quantity)
        {
            field("ABA Batch Production ABA Batch Consumption Pct."; Rec."ABA Batch Production ConsPct.")
            {
                ApplicationArea = All;
                Editable = false;
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
        addlast(Promoted)
        {
            group("ABA Batch Production Shop Floor Registrations")
            {
                Caption = 'Shop Floor Registrations';
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        Rec.GetItemTrackingLines();
    end;
    var
        LotOrSerialNo: Option LotNo,SerialNo;

}
