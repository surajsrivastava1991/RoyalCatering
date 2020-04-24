codeunit 50005 PurchPostExt
{
    var
        PurchRequisitionG: Record "Purchase Indent Header";
        PurchRequisitionLineG: Record "Purchase Indent Line";
        FullyReceivedG: Boolean;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptLineInsert', '', true, true)]
    local procedure OnBeforePurchRcptLineInsert(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean; PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    begin
        FullyReceivedG := false;
        if PurchLine.Quantity = (PurchRcptLine.Quantity) + PurchLine."Quantity Received" then
            FullyReceivedG := true;
        PurchRequisitionLineG.Reset();
        PurchRequisitionLineG.SetRange("Ref. Document Type", PurchRequisitionLineG."Ref. Document Type"::"Purchase Order");
        PurchRequisitionLineG.SetRange("Ref. Document No.", PurchLine."Document No.");
        if PurchRequisitionLineG.FindSet() then
            repeat
                if FullyReceivedG then
                    PurchRequisitionLineG."Transaction Status" := PurchRequisitionLineG."Transaction Status"::Received
                else
                    PurchRequisitionLineG."Transaction Status" := PurchRequisitionLineG."Transaction Status"::"Partially Received";
                PurchRequisitionLineG.Modify(true);
            until PurchRequisitionLineG.Next = 0;
    end;
}