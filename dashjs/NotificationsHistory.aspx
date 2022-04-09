<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="NotificationsHistory.aspx.cs" Inherits="ManageUPPRM.dashjs.NotificationsHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        $(document).ready(function () {
            getNotifications();


        });

        function getNotifications() {
            call('/dashjs/NotificationsHistory.aspx/getNotifications', '{}', listNotifications);
        }

        function listNotifications(result) {

            $('#notificationList').html($('#notifications-content').tmpl(result.d));
            $('#tabPermissions').DataTable({
                "aoColumnDefs" : [
                    { "targets": 2, "visible" : false }, //Hides EventDate column
                    { "iDataSort": 2, "aTargets": 1 }  //Targets EventDate when sorting by When column
                ],
                "order": [[2, "desc"]] //Sets table default sorting column (EventDate)
            });
        }
    </script>
    <style>
        #tabPermissions .label i {
            width: 20px;
            height: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <!-- start container -->
            <div class="row">
                <div class="col-md-12">
                    <div class="tab-content">
                        <div class="tab-pane active" id="tab0">
                            <div class="row-fluid">
                                <div id="success-msg" class="alert alert-success span12" style="display: none;">Notification configuration has been changed</div>
                            </div>
                            
                            <div class="portlet box grey-silver">
                                <div class="portlet-title">
                                    <div class="caption">Notifications</div>
                                </div>
                                <div class="portlet-body">
                                    <table id="tabPermissions" class="table table-hover table-light">
                                        <thead>
                                            <tr>
                                                <th>Notification</th>
                                                <th>When</th>
                                                <th>Event Date</th>
                                            </tr>
                                        </thead>
                                        <tbody id="notificationList"></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/x-jquery-tmpl" id="notifications-content">
        <tr>
                            
            <td>
                <span class="label label-sm label-icon label-success" style="background-color: ${Color}">
                    <i class="fa ${Icon}"></i>
                    <!-- we can use different types => fa-bell-o fa-bolt fa-bullhorn -->
                </span>
                &nbsp;
                <a href="${link}">
                    ${EventDescription}
                </a>
            </td>
            <td>${friendlyTime}</td>
            <td>${EventDateAsString}</td>
        </tr>
    </script>
</asp:Content>
