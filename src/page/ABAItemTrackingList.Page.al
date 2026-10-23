page 70521 "ABA Item Tracking List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ABA Item Tracking List";
    Caption = 'Item Tracking List';

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Visible = not HideLotNo;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Visible = not HideSerialNo;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("Remaining Qty. (Base)"; Rec."Remaining Qty. (Base)")
                {
                    ApplicationArea = All;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        HideLotNo: Boolean;
        HideSerialNo: Boolean;

    internal procedure SetTempRecords(var ItemTrackingList: Record "ABA Item Tracking List" temporary)
    begin
        if ItemTrackingList.Findset() then begin
            repeat
                Rec := ItemTrackingList;
                Rec.Insert();
            until ItemTrackingList.Next() = 0;
        end;
    end;

    internal procedure SetPage(pHideLotNo: Boolean; pHideSerialNo: Boolean)
    begin
        HideLotNo := pHideLotNo;
        HideSerialNo := pHideSerialNo;
    end;
}
