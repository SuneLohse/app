pageextension 70535 "ABA Shop Floor Overview" extends "SCB Capacity Load Overview"
{
    // layout
    // {
    //     addafter(OperationLines)
    //     {
    //         part(ComponentLines; "SCB Components Lines")
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Components';
    //             Visible = ShowComponentLines;
    //         }
    //     }
    // }

    // actions
    // {
    //     addafter(ShowTheOperationLines)
    //     {
    //         action(ShowHideComponentLines)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Show/Hide Components';
    //             Image = ShowSelected;
    //             ToolTip = 'Executes the Show/Hide Components action.';

    //             trigger OnAction()
    //             begin
    //                 if ShowComponentLines then
    //                     ShowComponentLines := false
    //                 else begin
    //                     ShowComponentLines := true;
    //                     CurrPage.ComponentLines.Page.SetFilters(Rec);
    //                 end;
    //                 CurrPage.Update();
    //             end;
    //         }
    //         action(UpdateComponentLines)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Update Components';
    //             Image = RefreshText;
    //             ToolTip = 'Executes the Update Components action.';

    //             trigger OnAction()
    //             begin
    //                 CurrPage.ComponentLines.Page.SetFilters(Rec);
    //             end;
    //         }
    //     }
    //     addafter(ShowTheOperationLines_Promoted)
    //     {
    //         actionref(ShowHideComponentLines_Promoted; ShowHideComponentLines)
    //         { }
    //     }
    //     addafter("Update Operations_Promoted")
    //     {
    //         actionref(UpdateComponentLines_Promoted; UpdateComponentLines)
    //         { }
    //     }
    // }

    // var
    //     ShowComponentLines: Boolean;
}
