pageextension 70530 "ABA Batch Prod. Order Lines" extends "Released Prod. Order Lines"
{
    actions
    {
        addlast(Processing)
        {
            action("ABA Batch Split Prod. Order Line")
            {
                ApplicationArea = All;
                Caption = 'Split Line';
                Image = Split;
                ToolTip = 'Splits the selected line into several lines with the quantity divided evenly between them.';

                trigger OnAction()
                begin
                    BatchProductionFunctions.SplitProdOrderLine(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
}
