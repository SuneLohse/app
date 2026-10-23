pageextension 70532 "ABA Batch Firm Prod. Line Ext" extends "Firm Planned Prod. Order Lines"
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
            action("ABA Production Order Matrix")
            {
                ApplicationArea = All;
                Caption = 'Production Order Matrix';
                Image = Totals;
                ToolTip = 'Opens the production order matrix.';

                trigger OnAction()
                begin
                    BatchProductionFunctions.PrepareProdOrderCompMatrix(Rec);
                    //Page.Run(Page::"ABA Production Order Matrix");
                end;
            }
        }
    }

    var
        BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
}
