tableextension 70525 "ABA IJL Batch Production" extends "Item Journal Line"
{
    fields
    {
        field(70525; "ABA Lot No."; Code[50])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                BatchProductionFunctions.UpdateItemTrackingFromILL(Rec);
            end;
        }
        field(70526; "ABA Serial No."; Code[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                BatchProductionFunctions.UpdateItemTrackingFromILL(Rec);
            end;
        }
        field(70527; "ABA Add Lot Qty"; Decimal)
        {
            Caption = 'Add Lot Qty';
            DataClassification = CustomerContent;
        }
        field(70528; "ABA Add Serial Qty"; Decimal)
        {
            Caption = 'Add Serial Qty';
            DataClassification = CustomerContent;
        }
        field(70529; "ABA Tracked Lot Qty"; Decimal)
        {
            Caption = 'Tracked Lot Qty';
            decimalplaces = 0:5;
            FieldClass = FlowField;            
            CalcFormula = -Sum("Reservation Entry"."Qty. to Handle (Base)" where(
                "Source Type" = const(Database::"Item Journal Line"),
                "Source Subtype" = field("Entry Type"),
                "Source ID" = field("Journal Template Name"),
                "Source Ref. No." = field("Line No.")));
            
            trigger OnLookup()
            begin
                Rec.OpenItemTrackingLines(false);
            end;
        }
        field(70535; "ABA Batch Production ConsPct."; Decimal)
        {
            Caption = 'Consumption Percentage';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
    }
    internal procedure AddLotOrSerialNo(LotOrSerialNo: Option LotNo,SerialNo)
        var
            BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
        begin
            if BatchProductionFunctions.LookupSimpleItemTracking(Rec."ABA Lot No.", Rec."ABA Serial No.", LotOrSerialNo) then begin
                BatchProductionFunctions.AddLotOrSerialNo(Rec."Item No.", Rec."Variant Code", Rec."ABA Lot No.", Rec."ABA Serial No.", Rec."Location Code", LotOrSerialNo, Rec."Quantity (Base)", Rec."ABA Add Lot Qty", Rec."ABA Add Serial Qty");
                Rec.validate("ABA Serial No.");
                Rec.validate("ABA Lot No.");
            end else begin
                Rec.OpenItemTrackingLines(false);
            end;
        end;

         internal procedure GetItemTrackingLines()
    var
        LotTrackingNo: Code[50];
        LotQtyToHandleBase: Decimal;
        SerialTrackingNo: Code[50];
        SerialQtyToHandleBase: Decimal;
    begin
        BatchProductionFunctions.GetItemTrackingLines(Database::"Item Journal Line", Rec."Entry Type".AsInteger(), Rec."Journal Template Name", 
                                Rec."Line No.", 0, LotTrackingNo, LotQtyToHandleBase, SerialTrackingNo, SerialQtyToHandleBase);

        Rec."ABA Lot No." := LotTrackingNo;
        Rec."ABA Add Lot Qty" := LotQtyToHandleBase;
        Rec."ABA Serial No." := SerialTrackingNo;
        Rec."ABA Add Serial Qty" := SerialQtyToHandleBase;
    end;

    var
        BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
}
