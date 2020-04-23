codeunit 50000 "General Ledger Posting"
{
    trigger OnRun()
    begin

    end;

    procedure TransferOrderToItemJournal(TransferHeaderP: Record "Transfer Header")
    var
        ItemJournalLineL: Record "Item Journal Line";
        TransferLineL: Record "Transfer Line";
        LocationL: Record Location;
        TransferReceiptHeaderL: Record "Transfer Receipt Header";
        GeneralLedgerSetupL: Record "General Ledger Setup";
        ItemjournalBatchL: Record "Item Journal Batch";
        DocumentNoL: Code[20];
    begin
        LineNoG := 0;
        GeneralLedgerSetupL.Get();
        LocationL.Get(TransferHeaderP."Transfer-to Code");
        if LocationL."Location Type" = LocationL."Location Type"::" " then
            exit;

        TransferReceiptHeaderL.Reset();
        TransferReceiptHeaderL.SetRange("Transfer Order No.", TransferHeaderP."No.");
        if TransferReceiptHeaderL.FindFirst() then;

        ItemjournalBatchL.Get(LocationL."Item Template Name", LocationL."Item Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(ItemjournalBatchL."No. Series", WorkDate(), true);
        DocumentNoL := IncStr(DocumentNoL);

        ItemJournalLineL.Reset();
        ItemJournalLineL.SetRange("Journal Template Name", LocationL."Item Template Name");
        ItemJournalLineL.setrange("Journal Batch Name", LocationL."Item Batch Name");
        ItemJournalLineL.DeleteAll();

        TransferLineL.Reset();
        TransferLineL.SetRange("Document No.", TransferHeaderP."No.");
        TransferLineL.SetRange("Derived From Line No.", 0);
        if TransferLineL.FindSet() then
            repeat
                ItemJournalLineL.Init();
                ItemJournalLineL.VALIDATE("Journal Template Name", LocationL."Item Template Name");
                ItemJournalLineL.VALIDATE("Journal Batch Name", LocationL."Item Batch Name");
                ItemJournalLineL."Line No." := LineNoG + 10000;
                ItemJournalLineL."Document No." := DocumentNoL;
                ItemJournalLineL."Posting Date" := TransferHeaderP."Posting Date";
                ItemJournalLineL."Entry Type" := ItemJournalLineL."Entry Type"::Sale;
                ItemJournalLineL.VALIDATE("Item No.", TransferLineL."Item No.");
                ItemJournalLineL.VALIDATE("Location Code", TransferHeaderP."Transfer-to Code");
                ItemJournalLineL.Validate(Quantity, TransferLineL.Quantity);
                ItemJournalLineL.Validate("Unit of Measure Code", TransferLineL."Unit of Measure Code");
                ItemJournalLineL.validate("Shortcut Dimension 1 Code", LocationL."Project Code");
                ItemJournalLineL."Reference Document No." := TransferReceiptHeaderL."No.";  //Added  050420

                if ItemJournalLineL.Insert(true) then;
                //  Message('Item Journal Has been Inserted');
                LineNoG += 10000;
            until TransferLineL.Next() = 0;
    end;

    procedure PurchaseOrderToItemJournal(PurchaseHeaderP: Record "Purchase Header")
    var
        ItemJournalLineL: Record "Item Journal Line";
        PurchaseLineL: Record "Purchase Line";
        LocationL: Record Location;
        GeneralLedgerSetupL: Record "General Ledger Setup";
        ItemjournalBatchL: Record "Item Journal Batch";
        DocumentNoL: Code[20];
    begin
        LineNoG := 0;
        GeneralLedgerSetupL.Get();


        LocationL.Get(PurchaseHeaderP."location Code");
        if LocationL."Location Type" = LocationL."Location Type"::" " then
            exit;
        //Deletion the previous entries
        ItemJournalLineL.Reset();
        ItemJournalLineL.SetRange("Journal Template Name", LocationL."Item Template Name");
        ItemJournalLineL.setrange("Journal Batch Name", LocationL."Item Batch Name");
        ItemJournalLineL.DeleteAll(true);

        ItemjournalBatchL.Get(LocationL."Item Template Name", LocationL."Item Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(ItemjournalBatchL."No. Series", WorkDate(), true);
        DocumentNoL := IncStr(DocumentNoL);



        //Creation of Item Journal Line with Entry Type Sales
        PurchaseLineL.Reset();
        PurchaseLineL.SetRange("Document No.", PurchaseHeaderP."No.");
        PurchaseLineL.Setfilter("Qty. to Receive", '<>%1', 0);
        if PurchaseLineL.FindSet() then
            repeat
                If (PurchaseLineL."Qty. to Receive" - PurchaseLineL."Qty To Reject") = 0 then
                    Exit;
                ItemJournalLineL.Init();
                ItemJournalLineL.VALIDATE("Journal Template Name", LocationL."Item Template Name");
                ItemJournalLineL.VALIDATE("Journal Batch Name", LocationL."Item Batch Name");
                ItemJournalLineL."Line No." := LineNoG + 10000;
                ItemJournalLineL."Document No." := DocumentNoL;
                ItemJournalLineL."Posting Date" := PurchaseHeaderP."Posting Date";
                ItemJournalLineL."Entry Type" := ItemJournalLineL."Entry Type"::Sale;
                ItemJournalLineL.VALIDATE("Item No.", PurchaseLineL."No.");
                ItemJournalLineL.VALIDATE("Location Code", PurchaseHeaderP."location Code");
                ItemJournalLineL.Validate(Quantity, PurchaseLineL."Qty. to Receive" - PurchaseLineL."Qty To Reject");   //110420
                ItemJournalLineL.Validate("Unit of Measure Code", PurchaseLineL."Unit of Measure Code");
                ItemJournalLineL.validate("Shortcut Dimension 1 Code", LocationL."Project Code");
                if ItemJournalLineL.Insert(true) then;
                LineNoG += 10000;
            until PurchaseLineL.Next() = 0;
    end;

    procedure CostAllocationToGenJournal(CostAllocationP: Record "Cost Allocation Header")
    var
        GenJournalLineL: Record "Gen. Journal Line";
        CostAllocationLineL: Record "Cost Allocation Line";
        LocationL: Record Location;
        GeneralLedgerSetupL: Record "General Ledger Setup";
        InventorySetupL: Record "Inventory Setup";
        GenjournalbatchL: Record "Gen. Journal Batch";
        DocumentNoL: Code[20];
    begin
        InventorySetupL.Get();
        LineNoG := 0;
        GeneralLedgerSetupL.Get();
        LocationL.Get(CostAllocationP."Bulk Location");
        LocationL.TestField("Journal Template Name");
        LocationL.TestField("Journal Batch Name");
        if LocationL."Location Type" = LocationL."Location Type"::" " then
            exit;
        //Deletion the previous entries
        GenJournalLineL.Reset();
        GenJournalLineL.SetRange("Journal Template Name", LocationL."Journal Template Name");
        GenJournalLineL.setrange("Journal Batch Name", LocationL."journal Batch Name");
        GenJournalLineL.DeleteAll();
        GenjournalbatchL.Get(LocationL."Journal Template Name", LocationL."journal Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(GenjournalbatchL."No. Series", CostAllocationP."From Date", true);

        //Header Creation
        GenJournalLineL.Init();
        GenJournalLineL.VALIDATE("Journal Template Name", LocationL."Journal Template Name");
        GenJournalLineL.VALIDATE("Journal Batch Name", LocationL."journal Batch Name");
        GenJournalLineL."Line No." := LineNoG + 10000;
        GenJournalLineL."Document No." := DocumentNoL;
        GenJournalLineL."Posting Date" := CostAllocationP."To Date";
        GenJournalLineL."Account Type" := GenJournalLineL."Account Type"::"G/L Account";
        GenJournalLineL.VALIDATE("Account No.", InventorySetupL."Kitchen Cost Account");
        GenJournalLineL.VALIDATE(Amount, -CostAllocationP."Bulk Allocation Cost");
        GenJournalLineL.validate("Shortcut Dimension 1 Code", LocationL."Project Code");
        GenJournalLineL."CL from Date" := CostAllocationP."From Date";
        GenJournalLineL."CL To Date" := CostAllocationP."To Date";
        GenJournalLineL."Bulk Kitchen" := CostAllocationP."Bulk Location";

        if GenJournalLineL.Insert(true) then;
        LineNoG += 10000;

        //Creation of Item Journal Line with Entry Type Sales
        CostAllocationLineL.Reset();
        CostAllocationLineL.SetRange("From Date", CostAllocationP."From Date");
        CostAllocationLineL.SetRange("To Date", CostAllocationP."To Date");
        CostAllocationLineL.SetRange("Bulk Location", CostAllocationP."Bulk Location");
        CostAllocationLineL.SetFilter("Allocated Cost Manual", '<>%1', 0);
        if CostAllocationLineL.FindSet() then
            repeat
                CreationGenJournalLines(CostAllocationLineL, LocationL, DocumentNoL, LineNoG);

            until CostAllocationLineL.Next() = 0;
        CostAllocationP."Journal Created" := true;
        CostAllocationP."Voucher No.(Pre)" := DocumentNoL;
        CostAllocationP.Modify(true);

    end;

    procedure CreationGenJournalLines(CostAllocationLineP: Record "Cost Allocation Line"; LocationP: Record Location; DocumentNoP: Code[20]; LineNoP: Integer)
    var
        GenJournalLineL: Record "Gen. Journal Line";
        InventorySetupL: Record "Inventory Setup";


    begin
        InventorySetupL.Get();

        GenJournalLineL.Init();
        GenJournalLineL.VALIDATE("Journal Template Name", LocationP."Journal Template Name");
        GenJournalLineL.VALIDATE("Journal Batch Name", LocationP."journal Batch Name");
        GenJournalLineL."Line No." := LineNoP + 10000;
        GenJournalLineL."Document No." := DocumentNoP;
        GenJournalLineL."Posting Date" := CostAllocationLineP."To Date";
        GenJournalLineL."Account Type" := GenJournalLineL."Account Type"::"G/L Account";
        GenJournalLineL.VALIDATE("Account No.", InventorySetupL."Kitchen Cost Account");
        GenJournalLineL.VALIDATE(Amount, CostAllocationLineP."Allocated Cost Manual");
        GenJournalLineL.validate("Shortcut Dimension 1 Code", CostAllocationLineP."Project No.");
        GenJournalLineL."CL from Date" := CostAllocationLineP."From Date";
        GenJournalLineL."CL To Date" := CostAllocationLineP."To Date";
        GenJournalLineL."Bulk Kitchen" := CostAllocationLineP."Bulk Location";
        if GenJournalLineL.Insert(true) then;
        LineNoG += 10000;
    end;


    procedure PurchaseOrderRejectToItemJournal(PurchaseHeaderP: Record "Purchase Header"; PurchLineP: Record "Purchase Line")
    var
        ItemJournalLineL: Record "Item Journal Line";
        GeneralLedgerSetupL: Record "General Ledger Setup";
        ItemjournalBatchL: Record "Item Journal Batch";
        LocationL: Record Location;
        DocumentNoL: Code[20];

    begin
        LineNoG := 0;
        GeneralLedgerSetupL.Get();
        LocationL.Get(PurchaseHeaderP."Location Code");

        LocationL.TestField("Reject Location");

        ItemjournalBatchL.Get(LocationL."Transfer Template Name", LocationL."Transfer Batch Name");
        DocumentNoL := NoSeriesManagementG.GetNextNo(ItemjournalBatchL."No. Series", WorkDate(), true);
        DocumentNoL := IncStr(DocumentNoL);

        //Deletion the previous Entries
        ItemJournalLineL.Reset();
        ItemJournalLineL.SetRange("Journal Template Name", LocationL."Transfer Template Name");
        ItemJournalLineL.setrange("Journal Batch Name", LocationL."Transfer Batch Name");
        ItemJournalLineL.DeleteAll();

        //Creation of Item Journal Line with Entry Type Sales
        PurchLineP.Reset();
        PurchLineP.SetRange("Document No.", PurchaseHeaderP."No.");
        PurchLineP.SetRange("Document Type", PurchaseHeaderP."Document Type");
        PurchLineP.Setfilter("Qty To Reject", '<>%1', 0);
        if PurchLineP.FindFirst() then
            repeat
                ItemJournalLineL.Init();
                ItemJournalLineL.VALIDATE("Journal Template Name", ItemjournalBatchL."Journal Template Name");
                ItemJournalLineL.VALIDATE("Journal Batch Name", ItemjournalBatchL.Name);
                ItemJournalLineL."Line No." := LineNoG + 10000;
                ItemJournalLineL."Document No." := DocumentNoL;
                ItemJournalLineL."Posting Date" := PurchaseHeaderP."Posting Date";
                ItemJournalLineL."Entry Type" := ItemJournalLineL."Entry Type"::Transfer;
                ItemJournalLineL.VALIDATE("Item No.", PurchLineP."No.");
                ItemJournalLineL.VALIDATE("Location Code", PurchaseHeaderP."location Code");
                ItemJournalLineL.Validate("New Location Code", LocationL."Reject Location");
                ItemJournalLineL.Validate(Quantity, PurchLineP."Qty To Reject");   //110420
                ItemJournalLineL.Validate("Unit of Measure Code", PurchLineP."Unit of Measure Code");
                ItemJournalLineL.validate("Shortcut Dimension 1 Code", LocationL."Project Code");
                ItemJournalLineL.validate("New Shortcut Dimension 1 Code", LocationL."Project Code");
                ItemJournalLineL."Source Code" := 'RECLASSJNL';
                if ItemJournalLineL.Insert(true) then;
                LineNoG += 10000;
            until PurchLineP.Next() = 0;
    end;

    var
        NoSeriesManagementG: Codeunit NoSeriesManagement;

        LineNoG: Integer;
}