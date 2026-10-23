codeunit 70526 "ABA Batch Subscriber Events"
{
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterValidateEvent', 'Quantity', false, false)]
    local procedure OnAfterValidateItemNoTransferItemMasterData(var Rec: Record "Item Journal Line"; xRec: Record "Item Journal Line")
    var
       BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
    begin
        BatchProductionFunctions.CalculateItemJournalPct(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertTransferItemMasterData(var Rec: Record "Item Journal Line"; RunTrigger: Boolean)
    var
       BatchProductionFunctions: Codeunit "ABA Batch Production Functions";
    begin
        // if not RunTrigger then
        //     exit;
        BatchProductionFunctions.CalculateItemJournalPct(Rec);
    end;
    
    var
        SubscriberEvents: Codeunit "SCB Subscriber Events 682";
}
