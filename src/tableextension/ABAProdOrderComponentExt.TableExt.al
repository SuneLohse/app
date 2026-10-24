tableextension 70531 "ABA Prod. Order Component Ext" extends "Prod. Order Component"
{
    fields
    {
        field(70525; "ABA Quantity to post"; Decimal)
        {
            Caption = 'Quantity to post';
            DataClassification = CustomerContent;
            Decimalplaces = 0 : 5;
        }
        field(70530; "ABA Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                BatchProductionFunctions.UpdateItemTrackingFromProdComp(Rec);
            end;
        }
        field(70531; "ABA Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                BatchProductionFunctions.UpdateItemTrackingFromProdComp(Rec);
            end;
        }
        field(70532; "ABA Add Lot Qty"; Decimal)
        {
            Caption = 'Add Lot Qty';
            DataClassification = CustomerContent;
        }
        field(70533; "ABA Add Serial Qty"; Decimal)
        {
            Caption = 'Add Serial Qty';
            DataClassification = CustomerContent;
        }
        field(70534; "ABA Tracked Lot Qty"; Decimal)
        {
            Caption = 'Tracked Lot Qty';
            decimalplaces = 0:5;
            FieldClass = FlowField;
            CalcFormula = -Sum("Reservation Entry"."Qty. to Handle (Base)" where(
                "Source Type" = const(Database::"Prod. Order Component"),
                "Source Subtype" = field(Status),
                "Source ID" = field("Prod. Order No."),
                "Source Ref. No." = field("Line No."),
                "Source Prod. Order Line" = field("Prod. Order Line No.")));
            trigger OnLookup()
            begin
                Rec.OpenItemTrackingLines();
            end;
        }
    }

    internal procedure AddLotOrSerialNo(LotOrSerialNo: Option LotNo,SerialNo)
        var
            BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
        begin
            if BatchProductionFunctions.LookupSimpleItemTracking(Rec."ABA Lot No.", Rec."ABA Serial No.", LotOrSerialNo) then begin
                BatchProductionFunctions.AddLotOrSerialNo(Rec."Item No.", Rec."Variant Code", Rec."ABA Lot No.", Rec."ABA Serial No.", Rec."Location Code", LotOrSerialNo, Rec."Remaining Qty. (Base)", Rec."ABA Add Lot Qty", Rec."ABA Add Serial Qty");
                    Rec.validate("ABA Serial No.");
                    Rec.validate("ABA Lot No.");
            end else begin
                Rec.OpenItemTrackingLines();
            end;
        end;

    internal procedure GetItemTrackingLines()
    var
        LotTrackingNo: Code[50];
        LotQtyToHandleBase: Decimal;
        SerialTrackingNo: Code[50];
        SerialQtyToHandleBase: Decimal;
    begin
        BatchProductionFunctions.GetItemTrackingLines(Database::"Prod. Order Component", Rec.Status.AsInteger(), Rec."Prod. Order No.",
                                Rec."Line No.", Rec."Prod. Order Line No.",
                                LotTrackingNo, LotQtyToHandleBase, SerialTrackingNo, SerialQtyToHandleBase);

        Rec."ABA Lot No." := LotTrackingNo;
        Rec."ABA Add Lot Qty" := LotQtyToHandleBase;
        Rec."ABA Serial No." := SerialTrackingNo;
        Rec."ABA Add Serial Qty" := SerialQtyToHandleBase;
    end;

    var
        BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
}
