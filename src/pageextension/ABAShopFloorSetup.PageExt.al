pageextension 70537 "ABA Shop Floor Setup" extends "SCB Shop Floor Setup"
{
    layout
    {
        addafter(Flows)
        {
            group("ABA Information Matrix Templates")
            {
                Caption = 'Information Matrix Templates';
                field("ABA Prod Line Info. Matrix"; Rec."ABA Prod Line Info. Matrix")
                {
                    ApplicationArea = All;
                }
                field("ABA Component Info. Matrix"; Rec."ABA Component Info. Matrix")
                {
                    ApplicationArea = All;
                }
                field("ABA Routing Info. Matrix"; Rec."ABA Routing Info. Matrix")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
