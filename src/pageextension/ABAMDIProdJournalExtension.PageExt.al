pageextension 70526 "ABA MDI Prod Journal Extension" extends "Production Journal"
{
    layout
    {
        addlast(Control1)
        {
            field("SCB MDI Field 1"; Rec."SCB MDI Field 1")
            {
                ApplicationArea = All;
                Visible = Field1Visible;
            }
            field("SCB MDI Field 2"; Rec."SCB MDI Field 2")
            {
                ApplicationArea = All;
                Visible = Field2Visible;
            }
            field("SCB MDI Field 3"; Rec."SCB MDI Field 3")
            {
                ApplicationArea = All;
                Visible = Field3Visible;
            }
            field("SCB MDI Field 4"; Rec."SCB MDI Field 4")
            {
                ApplicationArea = All;
                Visible = Field4Visible;
            }
            field("SCB MDI Field 5"; Rec."SCB MDI Field 5")
            {
                ApplicationArea = All;
                Visible = Field5Visible;
            }
            field("SCB MDI Field 6"; Rec."SCB MDI Field 6")
            {
                ApplicationArea = All;
                Visible = Field6Visible;
            }
            field("SCB MDI Field 7"; Rec."SCB MDI Field 7")
            {
                ApplicationArea = All;
                Visible = Field7Visible;
            }
            field("SCB MDI Field 8"; Rec."SCB MDI Field 8")
            {
                ApplicationArea = All;
                Visible = Field8Visible;
            }
            field("SCB MDI Field 9"; Rec."SCB MDI Field 9")
            {
                ApplicationArea = All;
                Visible = Field9Visible;
            }
            field("SCB MDI Field 10"; Rec."SCB MDI Field 10")
            {
                ApplicationArea = All;
                Visible = Field10Visible;
            }
            field("SCB MDI Field 11"; Rec."SCB MDI Field 11")
            {
                ApplicationArea = All;
                Visible = Field11Visible;
            }
            field("SCB MDI Field 12"; Rec."SCB MDI Field 12")
            {
                ApplicationArea = All;
                Visible = Field12Visible;
            }
            field("SCB MDI Field 13"; Rec."SCB MDI Field 13")
            {
                ApplicationArea = All;
                Visible = Field13Visible;
            }
            field("SCB MDI Field 14"; Rec."SCB MDI Field 14")
            {
                ApplicationArea = All;
                Visible = Field14Visible;
            }
            field("SCB MDI Field 15"; Rec."SCB MDI Field 15")
            {
                ApplicationArea = All;
                Visible = Field15Visible;
            }
            field("SCB MDI Field 16"; Rec."SCB MDI Field 16")
            {
                ApplicationArea = All;
                Visible = Field16Visible;
            }
            field("SCB MDI Field 17"; Rec."SCB MDI Field 17")
            {
                ApplicationArea = All;
                Visible = Field17Visible;
            }
            field("SCB MDI Field 18"; Rec."SCB MDI Field 18")
            {
                ApplicationArea = All;
                Visible = Field18Visible;
            }
            field("SCB MDI Field 19"; Rec."SCB MDI Field 19")
            {
                ApplicationArea = All;
                Visible = Field19Visible;
            }
            field("SCB MDI Field 20"; Rec."SCB MDI Field 20")
            {
                ApplicationArea = All;
                Visible = Field20Visible;
            }
            field("SCB MDI Field 21"; Rec."SCB MDI Field 21")
            {
                ApplicationArea = All;
                Visible = Field21Visible;
            }
            field("SCB MDI Field 22"; Rec."SCB MDI Field 22")
            {
                ApplicationArea = All;
                Visible = Field22Visible;
            }
            field("SCB MDI Field 23"; Rec."SCB MDI Field 23")
            {
                ApplicationArea = All;
                Visible = Field23Visible;
            }
            field("SCB MDI Field 24"; Rec."SCB MDI Field 24")
            {
                ApplicationArea = All;
                Visible = Field24Visible;
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            action("ABA Batch Production SCB 682 Master Data Information")
            {
                Caption = 'Master Data Information';
                Image = SNInfo;
                ApplicationArea = All;
                Visible = ShowMasterDataInformation;
                ToolTip = 'Executes the Master Data Information action.';

                trigger OnAction()
                var
                    TypeVar: Option Header,Line,Footer,HeaderAndFooter,"Item Tracking";
                begin
                    MDIPageHelpers.MasterDataOnDocumentsSetPageRun('TABLE 83', Rec."Journal Template Name", Rec."Journal Batch Name", Format(Rec."Line No."), '', 0, TypeVar::Line);
                end;
            }
            action("ABA Batch Production SCB Information Matrix")
            {

                Image = ServiceItem;
                ApplicationArea = All;
                Visible = ShowMasterDataInformation;
                ShortcutKey = 'Shift+Ctrl+I';
                Caption = 'Information Matrix';
                ToolTip = 'Open up Information Matrix';

                trigger OnAction()
                begin
                    MDIPageHelpers.OpenInformationMatrix(Database::"Item Journal Line");
                end;
            }
        }
    }

    var
        MDIPageHelpers: Codeunit "SCB MDI Page Helpers";
        ReplicateMDIFunction: Codeunit "SCB Replicate MDI Function";
        ShowMasterDataInformation: Boolean;
        Field1Visible: Boolean;
        Field2Visible: Boolean;
        Field3Visible: Boolean;
        Field4Visible: Boolean;
        Field5Visible: Boolean;
        Field6Visible: Boolean;
        Field7Visible: Boolean;
        Field8Visible: Boolean;
        Field9Visible: Boolean;
        Field10Visible: Boolean;
        Field11Visible: Boolean;
        Field12Visible: Boolean;
        Field13Visible: Boolean;
        Field14Visible: Boolean;
        Field15Visible: Boolean;
        Field16Visible: Boolean;
        Field17Visible: Boolean;
        Field18Visible: Boolean;
        Field19Visible: Boolean;
        Field20Visible: Boolean;
        Field21Visible: Boolean;
        Field22Visible: Boolean;
        Field23Visible: Boolean;
        Field24Visible: Boolean;
        FieldCaptionText: array[30] of Text;
        FieldVisible: array[30] of Boolean;

    trigger OnOpenPage()
    var
        MDISetup: Record "SCB Master Data Inform. Setup";
        NotificationAppMgt: Codeunit "SCB 682 Notific. Management";
    begin
        //ShowMasterDataInformation := NotificationAppMgt.IsMasterDataEnabled();
        ShowMasterDataInformation := true; //SLO for test
        if ShowMasterDataInformation then begin
            //CurrPage."SCB.682 InformationCustFactBox".Page.SetGlobalType2(18);
            //CurrPage."SCB.682 InformationItemFactBox".Page.SetGlobalType2(27);
            BuildVisibleFields();
        end;
    end;

    local procedure BuildVisibleFields()
    begin
        ReplicateMDIFunction.GetCaption(83, FieldCaptionText, FieldVisible);
        Field1Visible := FieldVisible[1];
        Field2Visible := FieldVisible[2];
        Field3Visible := FieldVisible[3];
        Field4Visible := FieldVisible[4];
        Field5Visible := FieldVisible[5];
        Field6Visible := FieldVisible[6];
        Field7Visible := FieldVisible[7];
        Field8Visible := FieldVisible[8];
        Field9Visible := FieldVisible[9];
        Field10Visible := FieldVisible[10];
        Field11Visible := FieldVisible[11];
        Field12Visible := FieldVisible[12];
        Field13Visible := FieldVisible[13];
        Field14Visible := FieldVisible[14];
        Field15Visible := FieldVisible[15];
        Field16Visible := FieldVisible[16];
        Field17Visible := FieldVisible[17];
        Field18Visible := FieldVisible[18];
        Field19Visible := FieldVisible[19];
        Field20Visible := FieldVisible[20];
        Field21Visible := FieldVisible[21];
        Field22Visible := FieldVisible[22];
        Field23Visible := FieldVisible[23];
        Field24Visible := FieldVisible[24];
    end;
}
