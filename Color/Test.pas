unit Test;

interface

uses ActiveX;

//procedure WebBrowserScreenShot(const wb: TWebBrowser; const fileName: TFileName) ;

implementation

//procedure WebBrowserScreenShot(const wb: TWebBrowser; const fileName: TFileName) ;
//var
//  viewObject : IViewObject;
//  r : TRect;
//  bitmap : TBitmap;
//begin
//  if wb.Document <> nil then
//  begin
//    wb.Document.QueryInterface(IViewObject, viewObject) ;
//    if Assigned(viewObject) then
//    try
//      bitmap := TBitmap.Create;
//      try
//        r := Rect(0, 0, wb.Width, wb.Height) ;
//
//        bitmap.Height := wb.Height;
//        bitmap.Width := wb.Width;
//
//        viewObject.Draw(DVASPECT_CONTENT, 1, nil, nil, Application.Handle, bitmap.Canvas.Handle, @r, nil, nil, 0) ;
//
//        with TJPEGImage.Create do
//        try
//          Assign(bitmap) ;
//          SaveToFile(fileName) ;
//        finally
//          Free;
//        end;
//      finally
//        bitmap.Free;
//      end;
//    finally
//      viewObject._Release;
//    end;
//  end;
//end;

end.
