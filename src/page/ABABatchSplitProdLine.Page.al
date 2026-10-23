page 70520 "ABA Batch Split Prod. Line"
{
    PageType = StandardDialog;
    Caption = 'Split Production Order Line';

    layout
    {
        area(content)
        {
            field(NoOfLines; NoOfLines)
            {
                ApplicationArea = All;
                Caption = 'Number of Lines';
                MinValue = 2;
                ToolTip = 'Specifies the total number of lines to split the selected line into.';
            }
        }
    }

    var
        NoOfLines: Integer;

    internal procedure GetNoOfLines(): Integer
    begin
        exit(NoOfLines);
    end;

    internal procedure SetNoOfLines(NewNoOfLines: Integer)
    begin
        NoOfLines := NewNoOfLines;
    end;
}
