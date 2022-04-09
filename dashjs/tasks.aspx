<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="Static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="tasks.aspx.cs" Inherits="ManageUPPRM.dashjs.tasks" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <script type="text/javascript">if (typeof window.JSON === 'undefined') { document.write('<script src="../Scripts/json2.js"><\/script>'); }</script>

    <script type="text/javascript">

        var searchUser = '';
        var teamSubmittedForApproval = $.cookie("teamSubmittedForApproval") == 'true';
        var teamTasksByStatus = $.cookie("teamTasksByStatus") == 'true';

        $(document).ready(function () {
            $("#portlet-submitted-for-approval").data('team', teamSubmittedForApproval);
            $("#portlet-tasks-by-status").data('team', teamTasksByStatus);

            if (teamSubmittedForApproval) {
                $("#team-toggle-submitted-for-approval").addClass("active");
                $("#my-toggle-submitted-for-approval").removeClass("active");
            };

            if (teamTasksByStatus) {
                $("#team-toggle-tasks-by-status").addClass("active");
                $("#my-toggle-tasks-by-status").removeClass("active");
            };

            $('.tabbable-line li').on('click', function () {
                $(this).closest('.portlet.light').find('.expand').trigger('click');
            });

            $(".nav-tabs li").on('shown.bs.tab', function (e) {
                var container = $($(e.target).attr("href"));

                getTasks(container, $(this).data('action'));
            });

            $('.my-team-switch input.toggle').on('change', function (event) {
                var myTasks = $(this).val() == "my";
                var team = !myTasks,
                portletContainer = $(this).closest('div.portlet');
                portletContainer.data('team', team);
                portletContainer.find('.task-widget li.active a').trigger('shown.bs.tab');
                
                var portletID = portletContainer.attr('id');
                if (portletID == 'portlet-submitted-for-approval') {
                    $.cookie("teamSubmittedForApproval", team);
                } else if (portletID == 'portlet-tasks-by-status') {
                    $.cookie("teamTasksByStatus", team);
                }
            });

            $('.reload').on('click', function () {
                $(this).closest('div.portlet').find('.task-widget li.active a').trigger('shown.bs.tab');
                return false;
            });

            $('#create-task-button').on('click', function () {
                $('#create-task-modal').modal('show');
                return false;
            });

            $('#liTasks ul li a').on('click', function (e) {
                var selected = $(this).data('selected');

                if (!!selected) {
                    return showSelectedSection(selected);
                };

                return;
            });

            $('body').on('change', ".task-checkbox", function () {
                var portlet = $(this).closest('.portlet');
                var cancelButton = portlet.find(".cancel-tasks-button");
                var table = portlet.find('table');
                var nodes = table.DataTable().rows().nodes();
                var selectedCount = $(nodes).find('.task-checkbox:checked').length;

                if (selectedCount > 0) {
                    cancelButton.show();
                } else {
                    cancelButton.hide();
                }
            });

            $(".cancel-tasks-button").click(function () {
                var portlet = $(this).closest('.portlet');
                var table = portlet.find('table');
                var nodes = table.DataTable().rows().nodes();
                var selectedTasks = $(nodes).find('.task-checkbox:checked');

                bootbox.confirm("Are you sure you want to cancel the " + selectedTasks.length + " selected task assignments?", function (result) {
                    if (result) {
                        var selectedTaskIDs = selectedTasks.map(function () {
                            return $(this).data("taskId");
                        });

                        selectedTaskIDs = Array.prototype.slice.call(selectedTaskIDs);

                        //alert("The following tasks should be canceled right now: " + selectedTaskIDs.join());

                        bootbox.dialog({
                            title: 'Please enter a comment',
                            message: "<textarea class='form-control cancel-tasks-comment'/>",
                            buttons: {
                                danger: {
                                    label: "Cancel",
                                    className: "btn-default"
                                },
                                main: {
                                    label: "OK",
                                    className: "btn-primary",
                                    callback: function () {
                                        var comment = $(".cancel-tasks-comment").val();

                                        if (!comment) {
                                            bootbox.alert("Please enter a comment");
                                            return false;
                                        }

                                        //Cancel selectedTaskIDs
                                        call("/ManageUPWebService.asmx/CancelTasks", JSON.stringify({ taskIDs: selectedTaskIDs, comment: comment }), function (response) {
                                            response = response.d;

                                            if (response.Success) {
                                                bootbox.alert("The tasks were cancelled successfully");
                                            } else {
                                                bootbox.alert("An error occurred while trying to cancel the selected tasks");
                                            }

                                            $('.reload').click();
                                        });
                                    }
                                }
                            }

                        });

                        
                    }
                });
            });
        });

        function getTasks(container, actionID) {
            var portlet = container.closest('div.portlet');
            portlet.find(".cancel-tasks-button").hide();
            var team = portlet.data('team');

            $.ajax({
                type: "POST",
                url: "../ManageUpWebService.asmx/GetTasksRows",
                async: true,
                data: JSON.stringify({ category: actionID, team: team, linkToChart: false, audit: false }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    container.find('.table-container').hide();
                    Metronic.startPageLoading();
                },
                success: function (data) {
                    container.find('img.loader-img').remove();
                    Metronic.stopPageLoading();
                    var table = container.find('table');
                    if (data.d.length == 0) {
                        container.find('.loading-container').html('<h3>There are no Objectives</h3>');
                    }
                    else {
                        if (table.hasClass('dataTable')) {
                            table.DataTable().destroy();
                        };

                        table.find('tbody').html(data.d);

                        var columns = table.find('thead tr th').map(function (i, el) {
                            return { "visible": !$(el).hasClass('team-column') || team };
                        });

                        container.find('.tooltips').tooltip();
                        var table = container.find('table').DataTable({
                            "columns": columns,
                            stateSave: true,
                            "aoColumnDefs": [
                                { "targets": 0, "sortable": false }, //Hides EventDate column
                            ],
                            "stateLoadParams": function (settings, data) {
                                var columns = [];
                                $.each(settings.aoColumns, function (i, el) {
                                    columns.push({ "visible": el.bVisible });
                                });

                                $.each(data.columns, function (i, el) {
                                    el.visible = typeof (columns[i]) !== 'undefined' ? columns[i].visible : false;
                                });
                            }
                        });

                        if (searchUser) {
                            table.search(searchUser).draw();
                            searchUser = '';
                        };

                        //$('.task-checkbox').uniform();
                        var table = portlet.find('table');
                        var nodes = table.DataTable().rows().nodes();
                        var selectedTasks = $(nodes).find('.task-checkbox').uniform();;
                        container.find('.table-container').show();
                    };
                }
            });
        };

        function showSelectedSection(section, team, search) {
            searchUser = search;
            if (!!section) {
                section = section.replace(' ', '');
                $('#liTasks ul li a').parent().removeClass('active');

                setSubSection($('#liTasks ul li a[data-selected="' + section + '"]'));

                if (section == 'create') {
                    $('#create-task-modal').modal('show');
                    loadTaskForActiveTabs();
                    return false;
                }
                else if (section == 'template') {
                    return;
                    //todo;
                }
                else {
                    var selectedTab = $('li[data-action="' + section + '"] a'),
                        selectedPortlet = selectedTab.closest('div.portlet');

                    $('.collapse').not(selectedPortlet.find('.collapse')).trigger('click');
                    selectedPortlet.find('.expand').trigger('click');
                    selectedTab.tab('show');

                    if (team == "True") {
                        selectedPortlet.find('.my-team-switch > label:last input').trigger('click');
                    }
                    else {
                        loadTaskForActiveTabs();
                    };

                    return false;
                };
            };

            loadTaskForActiveTabs();
        };

        function loadTaskForActiveTabs() {
            $('.task-widget li.active a').trigger('shown.bs.tab');
        };
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">

            <!-- start container -->
            <div class="row">
                <div class="col-md-12" id="msg-container"></div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <a class="btn green tooltips" id="create-task-button" href="javascript:;">Create&nbsp;
                        <i class="fa fa-plus"></i>
                    </a>
                </div>
            </div>

            <div class="row margin-top-15">
                <div class="portlet light bordered" id="portlet-submitted-for-approval" data-team="false">
                    <div class="portlet-title" style="border: none;">
                        <div class="tabbable-line col-md-4">
                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.SubmittedForApproval %>" class="active">
                                    <a href="#SubmittedForApprovalContent" data-toggle="tab" class="withTooltip" data-title="These are items that you have submitted for approval">Sub for Approval </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.ApprovalRequests %>">
                                    <a href="#ApprovalRequestsContent" data-toggle="tab" class="withTooltip" data-title="These are items that other users submitted to you for your approval">Approval Req </a>
                                </li>
                            </ul>
                        </div>
                        <div class="col-md-8 tools text-right">
                            <a href="javascript:;" class="reload"></a>
                            <a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>
                            <div class="btn-group my-team-switch" data-toggle="buttons" id="my-team-switch-submitted-for-approval">
                                <label class="btn btn-default active withTooltip" id="my-toggle-submitted-for-approval" data-original-title="Show the Tasks and Objectives where you are the Assignee (owner)">
                                    <input type="radio" name="myTeam" value="my" class="toggle">
                                    My
                                </label>
                                <label class="btn btn-default withTooltip" id="team-toggle-submitted-for-approval" data-original-title="Show the Tasks and Objectives where you are assigned as a Viewer. These Tasks and Objectives may belong to users who report to you or members of your project teams and task forces.">
                                    <input type="radio" name="myTeam" value="team" class="toggle">
                                    Team
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane active" id="SubmittedForApprovalContent">

                                <div class="table-container">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>Name </th>
                                                <th>Description </th>
                                                <th>Approver </th>
                                                <th>Category </th>
                                                <th>Due</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                            <div class="tab-pane" id="ApprovalRequestsContent">
                                <div class="table-container">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th>Name </th>
                                                <th>Description </th>
                                                <th>Owner </th>
                                                <th>Category </th>
                                                <th>Due</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="portlet light bordered" id="portlet-tasks-by-status" data-team="false">
                    <div class="portlet-title " style="border: none;">
                        <div class="tabbable-line col-md-9">

                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">

                                <li class="active" data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Urgent %>">
                                    <a href="#UrgentTabContent" data-toggle="tab">Urgent </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.DueSoon %>">
                                    <a href="#UrgentTabContent" data-toggle="tab">Due Soon </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.New %>">
                                    <a href="#UrgentTabContent" data-toggle="tab">New </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Completed %>">
                                    <a href="#UrgentTabContent" data-toggle="tab">Completed </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Cancelled %>">
                                    <a href="#UrgentTabContent" data-toggle="tab">Cancelled </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.All %>">
                                    <a href="#UrgentTabContent" data-toggle="tab">All </a>
                                </li>

                            </ul>
                        </div>
                        <div class="col-md-3 tools text-right">
                            <a href="javascript:;" class="reload"></a>
                            <a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>
                            <button class="btn red tooltips cancel-tasks-button" type="button" style="display: none;">Cancel</button>
                            <div class="btn-group my-team-switch" id="my-team-switch-tasks-by-status" data-toggle="buttons">
                                <label class="btn btn-default active withTooltip" id="my-toggle-tasks-by-status" data-original-title="Show the Tasks and Objectives where you are the Assignee (owner)">
                                    <input type="radio" name="myTeam" value="my" class="toggle">
                                    My
                                </label>
                                <label class="btn btn-default withTooltip" id="team-toggle-tasks-by-status" data-original-title="Show the Tasks and Objectives where you are assigned as a Viewer. These Tasks and Objectives may belong to users who report to you or members of your project teams and task forces.">
                                    <input type="radio" name="myTeam" value="team" class="toggle">
                                    Team
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane active" id="UrgentTabContent">
                                <div class="table-container">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th>Name </th>
                                                <th>Description </th>
                                                <th class="team-column">Owner </th>
                                                <th>Category </th>
                                                <th>Due</th>
                                                <th>Progress</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="portlet light bordered" data-team="false">
                    <div class="portlet-title" style="border: none;">
                        <div class="tabbable-line col-md-4">
                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">
                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.BackUp %>">
                                    <a href="#BackUpContainer" data-toggle="tab" class="withTooltip" data-title="These are items where you are assigned as a Backup owner">Backup</a>
                                </li>
                            </ul>
                        </div>
                        <div class="tools">
                            <a href="javascript:;" class="reload"></a>
                            <a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>
                            <button class="btn red tooltips cancel-tasks-button" type="button" style="display: none;">Cancel</button>
                        </div>
                    </div>

                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane" id="BackUpContainer">
                                <div class="table-container">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th>Name </th>
                                                <th>Description </th>
                                                <th>Owner </th>
                                                <th>Category </th>
                                                <th>Due</th>
                                                <th>Progress</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="portlet light bordered" data-team="false">
                    <div class="portlet-title" style="border: none;">
                        <div class="tabbable-line col-md-4">
                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">
                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Personal %>">
                                    <a href="#PersonalContent" data-toggle="tab">Personal Tasks</a>
                                </li>
                            </ul>
                        </div>
                        <div class="tools">
                            <a href="javascript:;" class="reload"></a>
                            <a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>
                            <button class="btn red tooltips cancel-tasks-button" type="button" style="display: none;">Cancel</button>
                        </div>
                    </div>

                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane" id="PersonalContent">
                                <div class="table-container">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th></th>
                                                <th>Name </th>
                                                <th>Description</th>
                                                <th>Due</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="loading-container"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">
    <div class="modal fade" id="create-task-modal" tabindex="-1" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                    <h4 class="modal-title">Objectives</h4>
                </div>
                <div class="modal-body">
                    <a class="btn green tooltips" href="<%= Page.ContentLastWrite("/dashjs/addptask.aspx")%>" title="A Task that is personal to the owner, view and actionable only by Task owner">Personal Task</a>
                    <a class="btn green tooltips" href="<%= Page.ContentLastWrite("/dashjs/addtask.aspx")%>" title="A makeshift Task without SQUEEZE points. It may be assigned, viewed, and actionable by other people">Ad-Hoc Task</a>
                    <a class="btn green tooltips" href="<%= Page.ContentLastWrite("/dashjs/adddtask.aspx")%>" title="A standardized Objective with SQUEEZE points. It may be assigned, viewed, and actionable by other people">Template Objectives</a>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn red" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
