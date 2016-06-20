unit global;

interface

uses
  System.Classes, SysUtils, System.Notification,System.Net.HttpClient, System.Net.HttpClientComponent, System.Net.URLClient;

///  <summary>
///  ��������� ����������� ����������.
///  </summary>
///  <param name="DeviceID">
///  ID ��������������� ����������
///  </param>
///  <param name="DeviceToken">
///  ����� ��������������� ����������
///  </param>
procedure RegisterDevice(DeviceID : string; DeviceToken : string; push_key : string);


///  <summary>
///  ��������� ������ ��������� �� ����������.
///  </summary>
///  <param name="MessageText">
///  ����� ���������� ���������
///  </param>
///  <param name="BadgeNumber">
///  ����� ��������� �� ������ ����������
///  </param>
procedure ShowNotification(MessageText : string; BadgeNumber : integer);

const
  // �������� ��� ����� 
  DOMAIN: string = 'http://exemple/';

implementation


procedure RegisterDevice(DeviceID : string; DeviceToken : string; push_key : string);
var
  client: THTTPClient;
  response: IHTTPResponse;
  postdata: TStringList;
begin
 TThread.Synchronize(TThread.CurrentThread, procedure
  begin
       // ������ �����������
    client := THTTPClient.Create;
  try

    // ��������� ������ ��� ��������
    postdata := TStringList.Create;
    postdata.Add('deviceid=' + DeviceID);
    postdata.Add('token=' + DeviceToken);
    postdata.Add('push_key=' + push_key);
    {$ifdef ANDROID}
      postdata.Add('platform=android');
    {$else}
      postdata.Add('platform=ios');
    {$endif}

    // ���������� ������
	client.post(DOMAIN + 'register.php', postdata);
  finally
    // ����������� � ����������� ������
    client.Free;
  end;
    end);
end;



procedure ShowNotification(MessageText : string; BadgeNumber : integer);
var
  NotificationC: TNotificationCenter;
  Notification: TNotification;
begin

  // ������ ����� ����������� � ����������� ��� ��������
  NotificationC := TNotificationCenter.Create(nil);
  Notification := NotificationC.CreateNotification;

  try
    // ���� ����� ����������� �������������� ��������
      // ������������� ����� ���������
      Notification.Name := MessageText;
      Notification.AlertBody := MessageText;
      Notification.Title := MessageText;
      // �������� ���� ��� ������ ���������
      Notification.EnableSound := true;
      // ������������� ����� �� ������ ����������
      Notification.Number := BadgeNumber;
      NotificationC.ApplicationIconBadgeNumber := BadgeNumber;
      // ������� ��������� �� ����������
      NotificationC.PresentNotification(Notification);
  finally
    // ������� ����������
    Notification.DisposeOf;
    NotificationC.Free;
    NotificationC.DisposeOf;
  end;
end;

end.
