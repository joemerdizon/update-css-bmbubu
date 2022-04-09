<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterNewUi.Master" CodeBehind="TemplateTasks.aspx.cs" Inherits="ManageUPPRM.dashjs.TemplateTasks" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<%@ Register TagPrefix="uc" TagName="YouTubeModalPlayer" Src="~/UserControls/YouTubeModalPlayer.ascx" %>
<%@ Register TagPrefix="uc" TagName="ReferenceMaterialEditonModal" Src="~/UserControls/ReferenceMaterialEditonModal.ascx" %>
<%@ Register TagPrefix="uc" TagName="SubTaskTable" Src="~/UserControls/SubTaskTable.ascx" %>
<%@ Register TagPrefix="uc" TagName="UsersGroupModal" Src="~/UserControls/UsersGroupModal.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../dashjs/js/fuelUx/scheduler.js"></script>

    <script type="text/javascript">
        var _lastType = $.cookie('TemplateTasksSelectedTab') ? $.cookie('TemplateTasksSelectedTab') : '<%=ManageUPPRM.Catalogs.TaskCategory.Favorites %>';
        //var _lastType = '<%=ManageUPPRM.Catalogs.TaskCategory.Favorites %>';

        var assignableContent = window.location.href.indexOf('assignable=true') > -1;
        console.log('assignableContent');
        console.log(assignableContent);

        function assignable() {
            assignableContent = true;
        };

        $(document).ready(function () {
            if (_lastType == '<%=ManageUPPRM.Catalogs.TaskCategory.Favorites %>') {
                $("#favorites-tab").addClass("active");
                $("#all-tab").removeClass("active");
            } else if (_lastType == '<%=ManageUPPRM.Catalogs.TaskCategory.All %>') {
                $("#favorites-tab").removeClass("active");
                $("#all-tab").addClass("active");
            }

            $(".nav-tabs li").on('shown.bs.tab', function (e) {
                //var container = $($(e.target).attr("href"));

                var type = $(this).data('action');
                _lastType = type;
                $.cookie('TemplateTasksSelectedTab', type);

                InitializeTemplateTasks(type);
                //getTasks(container, $(this).data('action'));

            });

            $('body').on('click', '.archive-unarchive-template-task-btn', function () {
                var templateTaskID = $(this).data('templateTaskId');

                call("/ManageUPWebService.asmx/ArchiveOrUnarchiveTemplateTask", JSON.stringify({ templateTaskID: templateTaskID }), function (response) {
                    response = response.d;

                    if (!response.Success) {
                        bootbox.alert("An error occurred while trying to archive the selected tasks");
                    } else {
                        if (response.Data == 'SubmittedForApproval') {
                            bootbox.alert("The template task was submitted for approval");
                        } else if (response.Data == 'Updated') {
                            bootbox.alert("The template task status was changed successfully");
                        }
                    }

                    InitializeTemplateTasks(_lastType);
                });
            });

            $('select').select2({ width: '100%' });
            InitializeTemplateTasks(_lastType);

        });

        function doFavorite(taskId) {
            var checkbox = $('#chkFav' + taskId);

            var isChecked = checkbox.is(":checked");
            var params = '{ "taskId": ' + taskId + ', "state": ' + isChecked + ' }';
            var result = callActionOnServer('doFavorite', params, false, false);
        }

        function doAuditable(taskId) {

            var checkbox = $('#chkAudit' + taskId);

            var isChecked = checkbox.is(":checked");
            var params = '{ "taskId": ' + taskId + ', "isAuditable": ' + isChecked + ' }';
            call('TemplateTasks.aspx/doAuditable', params);
        }

        function doAssignable(taskId) {
            var checkbox = $('#chkAssign' + taskId);

            var isChecked = checkbox.is(":checked");
            var params = '{ "taskId": ' + taskId + ', "isAssignable": ' + isChecked + ' }';
            call('TemplateTasks.aspx/doAssignable', params);
        }

        function doInactive() {
            InitializeTemplateTasks(_lastType);
        }

        var aspxPage = 'TemplateTasks.aspx';
        function callActionOnServer(action, params, showLoading, hideLoading) {
            var res;
            if (showLoading) processLoading();

            $.ajax({
                type: "POST", url: aspxPage + "/" + action, data: params, contentType: "application/json; charset=utf-8", dataType: "json",
                success: function (result) {
                    res = result.d;
                },
                failure: function (response) {
                    alert(response.d);
                },
                async: false
            });

            if (hideLoading) endProcessLoading();
            return res;
        }

        function TemplateTaskDetail(taskID) {
            var url = "../dashjs/AdddTask.aspx?TemplateTaskID=" + taskID;
            $(location).attr('href', url);
        };

        function TemplateTaskView(taskID) {
            var url = "../dashjs/ViewdTask.aspx?TemplateTaskID=" + taskID;
            $(location).attr('href', url);
        };

        function InitializeTemplateTasks(category) {
            var table = $('#TemplateTaskTable');

            var checkbox = $('#<%=chkInactive.ClientID%>');
            var includeInactive = checkbox.is(":checked");

            var params = JSON.stringify({ category: category, includeInactive: includeInactive, onlyAssignable: assignableContent })
            $.ajax({
                dataType: 'json',
                data: params,
                contentType: "application/json; charset=utf-8",
                type: "POST",
                url: "../ManageUpWebService.asmx/GetTemplateTasksRows",
                beforeSend: function () {
                    table.hide();
                    Metronic.blockUI({ target: '#main-portlet-tasks' });
                },
                success: function (msg) {

                    if (table.hasClass('dataTable')) {
                        table.DataTable().destroy();
                    };

                    table.find("tbody").empty();
                    table.find("tbody").append(msg.d);

                    table.find('tbody tr td:nth-child(2)').each(function (i, e) {
                        applyTooltipIfTextIsTooLong($(e), 20, $('body'));
                    });

                    table.show();

                    if (!$('#EditTemplate').length || assignableContent) {
                        table.find('.edit-template-btn').hide();
                    };

                    //if (!$('#AssignPermission').length) {
                    //table.find('.assign-template-btn').hide();
                    //};

                    var columnsVisible = [];
                    $('#TemplateTaskTable thead tr th').each(function (i, el) {
                        columnsVisible[i] = !$(this).hasClass('not-assignable');
                    });

                    table.DataTable({
                        stateSave: true,
                        "stateLoadParams": function (settings, data) {
                            $.each(data.columns, function (i, el) {
                                el.visible = columnsVisible[i] || !assignableContent;

                            });
                        },
                        "columns": columnsVisible.map(function (visible) {
                            return { visible: visible };
                        })
                    });

                    Metronic.unblockUI('#main-portlet-tasks');
                },
                error: function (xhr, textStatus, error) {
                    if (typeof console == "object") {
                        console.log(xhr.status + "," + xhr.responseText + "," + textStatus + "," + error);
                    }
                }
            });
        };

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="modals" runat="server">
    <uc:UsersGroupModal ID="UsersGroupModal" runat="server" />
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <h3 id="PageTitle" runat="server" class="hide-on-content-only page-title">Template Tasks
                <small>standardized tasks with SQUEEZE points.</small>
            </h3>

            <div class="page-bar">
                <ul class="page-breadcrumb">
                    <li class="ms-hover">
                        <i class="fa fa-home"></i>
                        <a href="dashboardjsnew.aspx">Dashboard</a>
                        <i class="fa fa-angle-right"></i>
                    </li>
                    <li class="ms-hover">
                        <a href="#">Template Tasks</a>
                    </li>
                </ul>
            </div>

            <div class="row margin-bottom-20">
                <div class="col-md-6">
                    <a class="btn green tooltips" href="adddtask.aspx" runat="server" id="createTemplateTaskBtn">Create&nbsp;
                        <i class="fa fa-plus"></i>
                    </a>
                </div>
            </div>
            <div class="row template-task-table-container">
                <div class="portlet light bordered" id="main-portlet-tasks" data-team="false">
                    <div class="portlet-title" style="border: none;">


                        <div class="tabbable-line col-md-9">

                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">

                                <li class="active" data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Favorites %>" id="favorites-tab">
                                    <a href="#UrgentTabContent" data-toggle="tab">Favorite  </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.All %>" id="all-tab">
                                    <a href="#UrgentTabContent" data-toggle="tab">All </a>
                                </li>

                            </ul>
                        </div>
                    </div>

                    <div class="portlet-body">
                        <asp:CheckBox ID="chkInactive" onclick="doInactive();" runat="server" Text="Include Archived Templates" />
                    </div>

                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane active" id="UrgentTabContent">


                                <div class="table-container">
                                    <table id="TemplateTaskTable" class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th class="span2">Name</th>
                                                <th class="span3">Description</th>
                                                <th class="span1 not-assignable">Category</th>
                                                <th class="span2">Sub Category</th>
                                                <th class="span2 not-assignable">Created On</th>
                                                <th class="span2 withTooltip" data-title="Checking Favorite will include Template Task in Favorites Section">Favorite</th>
                                                <th class="span2 not-assignable not-assignable withTooltip" data-title="Checking Auditable will allow the Template Task to be viewed by persons with an audit permission">Auditable</th>
                                                <th class="span2 not-assignable withTooltip" data-title="Checking Assignable will allow the Template Task to be assigned by any user. These items will be listed under 'Opportunities' on the dashboard.">Assignable</th>
                                                <th class="span2">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="EditTemplate" ClientIDMode="Static" runat="server" />
    <asp:HiddenField ID="AssignPermission" ClientIDMode="Static" runat="server" />
</asp:Content>
