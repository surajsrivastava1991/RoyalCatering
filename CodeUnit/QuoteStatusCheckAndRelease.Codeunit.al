codeunit 50055 "After Release Purch Quote"
{
    trigger OnRun()
    begin

    end;

    var
        PurchaseQuoteHdrG: Record "Purchase Header";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        IndentLineG: Record "Purchase Indent Line";
        VendorQuoteG: Record "Vendors For Quotations";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterManualReleasePurchaseDoc', '', true, true)]
    local procedure OnAfterManualReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        with PurchaseHeader do begin
            if (Format(PurchaseHeader."Ref. Requisition ID") = '') then
                exit;
            if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Quote then
                exit;
            PurchaseQuoteHdrG.Reset();
            PurchaseQuoteHdrG.SetRange("Ref. Requisition ID", "Ref. Requisition ID");
            PurchaseQuoteHdrG.SetFilter("No.", '<>%1', "No.");
            if PurchaseQuoteHdrG.FindSet() then
                repeat
                    if PurchaseQuoteHdrG.Status = PurchaseQuoteHdrG.Status::"Pending Approval" then
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(PurchaseQuoteHdrG);
                    PurchaseQuoteHdrG."Quotation Status" := PurchaseQuoteHdrG."Quotation Status"::Cancelled;
                    PurchaseQuoteHdrG.Modify();
                until PurchaseQuoteHdrG.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterReleasePurchaseDoc', '', true, true)]
    //local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    local procedure OnAfterReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    begin
        if (Format(PurchaseHeader."Ref. Requisition ID") = '') then
            exit;
        with PurchaseHeader do begin
            if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Quote then
                exit;
            PurchaseQuoteHdrG.Reset();
            PurchaseQuoteHdrG.SetRange("Ref. Requisition ID", "Ref. Requisition ID");
            PurchaseQuoteHdrG.SetFilter("No.", '<>%1', "No.");
            if PurchaseQuoteHdrG.FindSet() then
                repeat
                    if PurchaseQuoteHdrG.Status = PurchaseQuoteHdrG.Status::"Pending Approval" then
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(PurchaseQuoteHdrG);
                    PurchaseQuoteHdrG."Quotation Status" := PurchaseQuoteHdrG."Quotation Status"::Cancelled;
                    PurchaseQuoteHdrG.Modify();
                until PurchaseQuoteHdrG.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnAfterInsertPurchOrderLine', '', true, true)]
    local procedure OnAfterInsertPurchOrderLine(var PurchaseQuoteLine: Record "Purchase Line"; var PurchaseOrderLine: Record "Purchase Line")
    begin
        /*
        IndentLineG.Reset();
        IndentLineG.SetRange("Ref. Document Type", IndentLineG."Ref. Document Type"::"Purchase Quote");
        IndentLineG.SetRange("Ref. Document No.", PurchaseQuoteLine."No.");
        IndentLineG.SetRange("Ref. Document Line No.", PurchaseQuoteLine."Line No.");
        IndentLineG.CalcFields(Quantity);
        if IndentLineG.FindSet() then
            repeat
                IndentLineG."Ref. Document Type" := IndentLineG."Ref. Document Type"::"Purchase Order";
                IndentLineG."Ref. Document No." := PurchaseOrderLine."Document No.";
                IndentLineG."Ref. Document Line No." := PurchaseOrderLine."Line No.";
                IndentLineG.Modify();
                UpdateRequisitionStatus(PurchaseOrderLine)
            until IndentLineG.next() = 0;
        */

        VendorQuoteG.Reset();
        VendorQuoteG.SetCurrentKey("Quote Doc. No.");
        VendorQuoteG.SetRange("Quote Doc. No.", PurchaseQuoteLine."Document No.");
        VendorQuoteG.SetRange("Quote Line No.", PurchaseQuoteLine."Line No.");
        if VendorQuoteG.FindSet() then
            repeat
                IndentLineG.Reset();
                IndentLineG.Get(VendorQuoteG."Document No.", VendorQuoteG."Line No.");
                IndentLineG."Ref. Document Type" := IndentLineG."Ref. Document Type"::"Purchase Order";
                IndentLineG."Ref. Document No." := PurchaseOrderLine."Document No.";
                IndentLineG."Ref. Document Line No." := PurchaseOrderLine."Line No.";
                IndentLineG.Modify();
                UpdateRequisitionStatus(PurchaseOrderLine);
            until VendorQuoteG.Next() = 0;
    end;

    procedure UpdateRequisitionStatus(var PurchaseQuoteLineP: Record "Purchase Line")
    var
        ReqWkshModified: Codeunit "Req. Wksh.-Make Order-Mofified";
    begin
        if IndentLineG.Quantity <= PurchaseQuoteLineP.Quantity then begin
            IndentLineG."Transaction Status" := IndentLineG."Transaction Status"::"Approved-Ordered";
            IndentLineG.Modify();
            ReqWkshModified.UpdateHeaderStatus(IndentLineG);
        end
        else begin
            IndentLineG."Transaction Status" := IndentLineG."Transaction Status"::"Approved-Partially Ordered";
            IndentLineG.Modify();
            ReqWkshModified.UpdateHeaderStatus(IndentLineG);
        end;
    end;
    //Releae quote validation
    [EventSubscriber(ObjectType::Codeunit, codeunit::"Purch.-Quote to Order (Yes/No)", 'OnBeforePurchQuoteToOrder', '', true, true)]
    local procedure OnBeforePurchQuoteToOrder(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        PurchaseHeader.TestField(Status, PurchaseHeader.Status::Released);
        PurchSetup.TestField("Archive Quotes", PurchSetup."Archive Quotes"::Always);
    end;
    //Delete Cancelled Purchase Quotes
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", 'OnBeforeDeletePurchQuote', '', true, true)]
    local procedure OnBeforeDeletePurchQuote(var QuotePurchHeader: Record "Purchase Header"; var OrderPurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        PurchHeaderL: Record "Purchase Header";
        PurchaseLineL: Record "Purchase Line";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin
        PurchHeaderL.Reset();
        PurchHeaderL.SetRange("Ref. Requisition ID", QuotePurchHeader."Ref. Requisition ID");
        PurchHeaderL.SetRange("Document Type", PurchHeaderL."Document Type"::Quote);
        if PurchHeaderL.FindSet() then
            repeat
                PurchaseLineL.Reset();
                PurchaseLineL.SetRange("Document Type", PurchHeaderL."Document Type");
                PurchaseLineL.SetRange("Document No.", PurchHeaderL."No.");
                ArchiveManagement.ArchPurchDocumentNoConfirm(PurchHeaderL);
                ApprovalsMgmt.DeleteApprovalEntries(PurchHeaderL.RecordId);
                PurchHeaderL.DeleteLinks();
                PurchHeaderL.Delete();
                PurchaseLineL.DeleteAll();
            until PurchHeaderL.Next() = 0;
    end;
}