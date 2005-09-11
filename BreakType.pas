{*
 * GetBreakType: Detects the type of line break in a file.
 * Jonas Raoni Soares da Silva <http://raoni.org>
 * https://github.com/jonasraoni/get-break-type
 *}

TBreakType = (btUnknown, btWindows, btMacintosh, btUnix, btBinary);

function GetBreakType(const Filename: string; const MaxDataToRead: Cardinal = 5 * 1024): TBreakType;
var
	FS: TFileStream;
	Buffer, BufferStart, BufferEnd: PChar;
begin
	Result := btUnknown;
	if not FileExists(Filename) then
		raise Exception.Create('GetBreakType: invalid file name');
	try
		FS := TFileStream.Create(Filename, fmOpenRead);
		GetMem(Buffer, MaxDataToRead + 1);
		BufferEnd := (Buffer + FS.Read(Buffer^, MaxDataToRead));
		BufferStart := Buffer;
		BufferEnd^ := #0;
	except
		raise Exception.Create('GetBreakType: error allocating memory');
	end;
	try
		while Buffer^ <> #0 do begin
			if Result = btUnknown then
				if Buffer^ = ASCII_CR then begin
					if (Buffer + 1)^ = ASCII_LF then begin
						Result := btWindows;
						Inc(Buffer);
					end
					else
						Result := btMacintosh;
				end
				else if Buffer^ = ASCII_LF then
					Result := btUnix;
			Inc(Buffer);
		end;
		if Buffer <> BufferEnd then
			Result := btBinary;
	finally
		FreeMem(BufferStart, MaxDataToRead + 1);
		FS.Free;
	end;
end;