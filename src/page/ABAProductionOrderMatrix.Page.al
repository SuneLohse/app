page 70522 "ABA Production Order Matrix"
{
    PageType = Document;
    Caption = 'Production Order Matrix';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            part(ProdLineMatrix; "ABA Production Line Matrix")
            {
                ApplicationArea = All;
                Caption = 'Production Line';
                Visible = ShowProdLines;
            }
            part(CompMatrix; "ABA Production Comp Matrix")
            {
                ApplicationArea = All;
                Caption = 'Components';
                Visible = ShowComponentLines;
            }
            part(RoutingMatrix; "ABA Production Routing Matrix")
            {
                ApplicationArea = All;
                Caption = 'Routing';
                Visible = ShowOperationLines;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ShowHideProdLines)
            {
                ApplicationArea = All;
                Caption = 'Show/Hide Order Lines';
                Image = ShowSelected;
                ToolTip = 'Executes the Show/Hide Order Lines action.';

                trigger OnAction()
                begin
                    if ShowProdLines then
                        ShowProdLines := false
                    else begin
                        ShowProdLines := true;
                        //CurrPage.ProductionOrderLines.Page.SetFilters(Rec);
                    end;
                //     Rec."Show Production Order Lines" := ShowProdLines;
                //     Rec.Modify();
                //     CurrPage.Update();
                end;
            }
            action(ShowOperationLines)
            {
                ApplicationArea = All;
                Caption = 'Show/Hide Operations';
                Image = ShowSelected;
                ToolTip = 'Executes the Show/Hide Operations action.';

                trigger OnAction()
                begin
                    if ShowOperationLines then
                        ShowOperationLines := false
                    else begin
                        ShowOperationLines := true;
                        //CurrPage.OperationLines.Page.SetFilters(Rec);
                    end;
                //     Rec."Show Operation Lines" := ShowOperationLines;
                //     CurrPage.Update();
                end;
            }
            action(ShowComponentLines)
            {
                ApplicationArea = All;
                Caption = 'Show/Hide Components';
                Image = ShowSelected;
                ToolTip = 'Executes the Show/Hide Components action.';

                trigger OnAction()
                begin
                    if ShowComponentLines then
                        ShowComponentLines := false
                    else begin
                        ShowComponentLines := true;
                        // CurrPage.ComponentLines.Page.SetFilters(Rec);
                    end;
                    // Rec."Show Component Lines" := ShowComponentLines;
                    // CurrPage.Update();
                end;
            }
        }
        area(Promoted)
        {
            actionref(ShowHideProdLines_Promoted; ShowHideProdLines)
            { }
            actionref(ShowTheOperationLines_Promoted; ShowOperationLines)
            { }
            actionref(ShowTheComponentLines_Promoted; ShowComponentLines)
            { }
        }
    }
    trigger OnOpenPage()
        begin
            ShowProdLines := true;
            ShowOperationLines := true;
            ShowComponentLines := true;    
        end;

    var
        ShowProdLines: Boolean;
        ShowOperationLines: Boolean;
        ShowComponentLines: Boolean;
}
