<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="Notifications.aspx.cs" Inherits="ManageUPPRM.dashjs.admin.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin</title>
    <script>
        $(document).ready(function () {
            loadUserNotifications();

            <%if (UserIsAdminOrClientAdmin())
	        {%>
                loadGlobalNotifications();
	        <%} %>

            $("#globalNotificationsList").on("click", "input[type='checkbox']", function () {
                var enabled = $(this).is(":checked");
                var notificationKey = $(this).data("notificationKey");
                var device = $(this).data("notificationDevice");
                var params = '{ "enabled": ' + enabled.toString() + ', "notificationKey": "' + notificationKey + '", "device": "' + device + '" }';
                callActionOnServer('saveGlobalNotification', params, function (response) {
                    response = response.d;

                    if (response.errors && response.errors.length > 0) {
                        showErrorMsj(response.errors[0]);
                    } else {
                        showSuccessMsj("Notification configuration has been changed");
                    }
                });
            });
        });

        function loadUserNotifications() {
            $('#userNotificationsList').html($('#user-notifications-content').tmpl(userNotificationMembers));

            Metronic.initUniform();
            applyTooltip($('.withTooltip'));
        }

        function loadGlobalNotifications() {
            $('#globalNotificationsList').html($('#global-notifications-content').tmpl(globalNotificationMembers));

            Metronic.initUniform();
            applyTooltip($('.withTooltip'));
        }

        function doChangeNotification(notificationKey, device) {
            var enabled = $('#chk_' + notificationKey + '_' + device).is(":checked");

            var params = '{ "enabled": ' + enabled.toString() + ', "notificationKey": "' + notificationKey + '", "device": "' + device + '" }';
            var result = callActionOnServer('saveNotification', params, function (response) {
                response = response.d;

                if (response.errors && response.errors.length > 0) {
                    showErrorMsj(response.errors[0]);
                } else {
                    showSuccessMsj("Notification configuration has been changed");
                }
            });
        }

        var aspxPage = 'notifications.aspx';


        function callActionOnServer(action, params, onSuccess) {
            var res;

            $.ajax({
                type: "POST", url: aspxPage + "/" + action, data: params, contentType: "application/json; charset=utf-8", dataType: "json",
                success: function (result) {
                    onSuccess(result);
                },
                failure: function (response) {
                    alert(response.d);
                },
                async: true
            });

            return res;
        }

        var showSuccessMsj = function () {
            var msg = $('#successMsj');
            if (msg.val() != '') {
                $('#success-msg').text(msg.val()).show('fast');
                setTimeout(function () {
                    $('#success-msg').hide('fast');
                    msg.val('');
                }, 5000);
            };
        };

        var showErrorMsj = function (message) {
            var msg = $('#errorMsj');
            if (msg.val() != '') {
                $('#error-msg').text(message).show('fast');
                setTimeout(function () {
                    $('#error-msg').hide('fast');
                    msg.val('');
                }, 5000);
            };
        };
    </script>
    <style>
        #userNotificationsList .center, #globalNotificationsList .center, .notifications-table th {
            text-align: center;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="page-content-wrapper">
        <div class="page-content">
            <!-- start container -->
            <div class="row">
                <div class="col-md-12">
                    <div class="portlet light bordered" data-team="false">
                        <div class="portlet-title " style="border: none;">
                            <div class="tabbable-line col-md-9">
                                <ul class="nav nav-tabs" id="AdminTabs">
                                    <asp:Literal ID="AdminMenu" runat="server" />
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab0">
                            <div class="row-fluid">
                                <div id="success-msg" class="alert alert-success span12" style="display: none;">Notification configuration has been changed</div>
                            </div>
                            <div class="row-fluid">
                                <div id="error-msg" class="alert alert-danger span12" style="display: none;"></div>
                            </div>
                            <div class="portlet light bordered">
                                <div class="portlet-title" style="border: none;">
                                    <div class="tabbable-line">
                                        <ul class="nav nav-tabs home-tabs nav-justified task-widget">
                                            <li class="active withTooltip" title="Configure your notification settings"><a href="#portlet_user_tab" data-toggle="tab">User Notifications</a></li>
                                            <%if (UserIsAdminOrClientAdmin())
	                                        {%>
                                                <li class="withTooltip" title="Configure the notification settings for every user (This configuration will be applied for every user if 'Users can configure notifications' setting is disabled on the site settings page)"><a href="#portlet_global_tab" data-toggle="tab">Global Notifications</a></li>
	                                        <%} %>
                                        </ul>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <div class="tab-content">
                                        <div class="tab-pane active" id="portlet_user_tab">
                                            <table class="table table-hover table-light notifications-table">
                                                <thead>
                                                    <tr>
                                                        <th>Notify me when there are</th>
                                                        <th>Notification Bar</th>
                                                        <th>Real time emails</th>
                                                        <th>Daily summary emails</th>
                                                        <th>SMS messages</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="userNotificationsList"></tbody>
                                            </table>
                                        </div>
                                        <div class="tab-pane" id="portlet_global_tab">
                                            <table class="table table-hover table-light notifications-table">
                                                <thead>
                                                    <tr>
                                                        <th>Notify me when there are</th>
                                                        <th>Notification Bar</th>
                                                        <th>Real time emails</th>
                                                        <th>Daily summary emails</th>
                                                        <th>SMS messages</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="globalNotificationsList"></tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/x-jquery-tmpl" id="user-notifications-content">
        <tr data-notifkey="${NotificationKey}">
            <td class="withTooltip" data-original-title="${Tooltip}"><b>${Name}</b></td>
            <td class="center">
                {{if AllowNotificationBar != false }}
                <input id="chk_${NotificationKey}_WE" {{if NotificationBar == true }} checked {{/if}} type="checkbox" onclick="doChangeNotification('${NotificationKey}', 'WE');" {{if DisableGroup }}disabled{{/if}}/>
                {{/if}}
            </td>
            <td class="center">
                {{if AllowRealTime != false }}
                <input id="chk_${NotificationKey}_MA" {{if RealTime == true }} checked {{/if}} type="checkbox" onclick="doChangeNotification('${NotificationKey}', 'MA');" {{if DisableGroup }}disabled{{/if}} />
                {{/if}}
            </td>
            <td class="center">
                {{if AllowSummary != false }}
                <input id="chk_${NotificationKey}_DS" {{if Summary == true }} checked {{/if}} type="checkbox" onclick="doChangeNotification('${NotificationKey}', 'DS');" {{if DisableGroup }}disabled{{/if}} />
                {{/if}}
            </td>
            <td class="center">
                {{if AllowSMS != false }}
                <input id="chk_${NotificationKey}_SM" {{if SMS == true }} checked {{/if}} type="checkbox" onclick="doChangeNotification('${NotificationKey}', 'SM');" {{if DisableGroup }}disabled{{/if}} />
                {{/if}}
            </td>
        </tr>
    </script>

    <script type="text/x-jquery-tmpl" id="global-notifications-content">
        <tr data-notifkey="${NotificationKey}">
            <td class="withTooltip" data-original-title="${Tooltip}"><b>${Name}</b></td>
            <td class="center">
                {{if AllowNotificationBar != false }}
                <input {{if NotificationBar == true }} checked {{/if}} type="checkbox" data-notification-key="${NotificationKey}" data-notification-device="WE" {{if DisableGroup }}disabled{{/if}} />
                {{/if}}
            </td>
            <td class="center">
                {{if AllowRealTime != false }}
                <input {{if RealTime == true }} checked {{/if}} type="checkbox" data-notification-key="${NotificationKey}" data-notification-device="MA" {{if DisableGroup }}disabled{{/if}} />
                {{/if}}
            </td>
            <td class="center">
                {{if AllowSummary != false }}
                <input {{if Summary == true }} checked {{/if}} type="checkbox" data-notification-key="${NotificationKey}" data-notification-device="DS" {{if DisableGroup }}disabled{{/if}} />
                {{/if}}
            </td>
            <td class="center">
                {{if AllowSMS != false }}
                <input {{if SMS == true }} checked {{/if}} type="checkbox" data-notification-key="${NotificationKey}" data-notification-device="SM" {{if DisableGroup }}disabled{{/if}} />
                {{/if}}
            </td>
        </tr>
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">
</asp:Content>

