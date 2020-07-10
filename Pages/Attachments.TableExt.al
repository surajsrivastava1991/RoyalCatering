tableextension 50113 "Attachments" extends "Document Attachment"
{
    Caption = 'Document Attachment';

    var
        FileManagement: Codeunit "File Management";
        NoDocumentAttachedErr: Label 'Please attach a document first.';
        EmptyFileNameErr: Label 'Please choose a file to attach.';
        NoContentErr: Label 'The selected file has no content. Please choose another file.';
        IncomingFileName: Text;
        DuplicateErr: Label 'This file is already attached to the document. Please choose another file.';

    procedure Export1(ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        if ID = 0 then
            exit;
        // Ensure document has value in DB
        if not "Document Reference ID".HasValue then
            exit;

        FullFileName := "File Name" + '.' + "File Extension";
        TempBlob.CreateOutStream(DocumentStream);
        "Document Reference ID".ExportStream(DocumentStream);
        exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    procedure HasPostedDocumentAttachment1("Record": Variant): Boolean
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        RecRef.GetTable(Record);
        SetRange("Table ID", RecRef.Number);
        case RecRef.Number of
            DATABASE::"Sales Invoice Header",
            DATABASE::"Sales Cr.Memo Header",
            DATABASE::"Purch. Inv. Header",
            DATABASE::"Purch. Cr. Memo Hdr.":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    SetRange("No.", RecNo);
                    exit(not IsEmpty);
                end;
        end;

        exit(false);
    end;

    procedure SaveAttachment1(RecRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob")
    var
        DocStream: InStream;
    begin

        if FileName = '' then
            Error(EmptyFileNameErr);
        // Validate file/media is not empty
        if not TempBlob.HasValue then
            Error(NoContentErr);

        TempBlob.CreateInStream(DocStream);
        InsertAttachment(DocStream, RecRef, FileName);
    end;

    procedure SaveAttachmentFromStream1(DocStream: InStream; RecRef: RecordRef; FileName: Text)
    begin

        if FileName = '' then
            Error(EmptyFileNameErr);

        InsertAttachment(DocStream, RecRef, FileName);
    end;

    local procedure InsertAttachment(DocStream: InStream; RecRef: RecordRef; FileName: Text)
    begin
        IncomingFileName := FileName;

        Validate("File Extension", FileManagement.GetExtension(IncomingFileName));
        Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(IncomingFileName), 1, MaxStrLen("File Name")));

        // IMPORTSTREAM(stream,description, mime-type,filename)
        // description and mime-type are set empty and will be automatically set by platform code from the stream
        "Document Reference ID".ImportStream(DocStream, '');
        if not "Document Reference ID".HasValue then
            Error(NoDocumentAttachedErr);

        InitFieldsFromRecRef1(RecRef);

        Insert(true);
    end;

    procedure InitFieldsFromRecRef1(RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        Validate("Table ID", RecRef.Number);

        case RecRef.Number of
            DATABASE::Customer,
            DATABASE::Vendor,
            DATABASE::Item,
            DATABASE::Employee,
            DATABASE::"Fixed Asset",
            DATABASE::Resource,
            DATABASE::Job:
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Header",
            DATABASE::"Purchase Header",
            DATABASE::"Sales Line",
            DATABASE::"Purchase Line":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    Validate("Document Type", DocType);

                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Line",
            DATABASE::"Purchase Line":
                begin
                    FieldRef := RecRef.Field(4);
                    LineNo := FieldRef.Value;
                    Validate("Line No.", LineNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Invoice Header",
            DATABASE::"Sales Cr.Memo Header",
            DATABASE::"Purch. Inv. Header",
            DATABASE::"Purch. Cr. Memo Hdr.":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            DATABASE::"Sales Invoice Line",
            DATABASE::"Sales Cr.Memo Line",
            DATABASE::"Purch. Inv. Line",
            DATABASE::"Purch. Cr. Memo Line":
                begin
                    FieldRef := RecRef.Field(3);
                    RecNo := FieldRef.Value;
                    Validate("No.", RecNo);

                    FieldRef := RecRef.Field(4);
                    LineNo := FieldRef.Value;
                    Validate("Line No.", LineNo);
                end;
        end;
    end;

    procedure FindUniqueFileName1(FileName: Text; FileExtension: Text): Text[250]
    var
        DocumentAttachmentMgmt: Codeunit "Document Attachment Mgmt";
        FileIndex: Integer;
        SourceFileName: Text[250];
    begin
        SourceFileName := CopyStr(FileName, 1, MaxStrLen(SourceFileName));
        while DocumentAttachmentMgmt.IsDuplicateFile("Table ID", "No.", "Document Type", "Line No.", FileName, FileExtension) DO BEGIN
            FileIndex += 1;
            FileName := GetNextFileName(SourceFileName, FileIndex);
        end;
        exit(CopyStr(StrSubstNo('%1.%2', FileName, FileExtension), 1, MaxStrLen(SourceFileName)));
    end;

    local procedure GetNextFileName(FileName: Text[250]; FileIndex: Integer): Text[250]
    begin
        exit(StrSubstNo('%1 (%2)', FileName, FileIndex));
    end;
}