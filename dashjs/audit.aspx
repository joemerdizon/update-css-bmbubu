<%@ Page Language="C#" AutoEventWireup="true" ClientIDMode="static" MasterPageFile="~/MasterNewUi.Master" CodeBehind="audit.aspx.cs" Inherits="ManageUPPRM.dashjs.audit" %>

<%@ Import Namespace="ManageUPPRM.Extensions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">


    <script>if (typeof window.JSON === 'undefined') { document.write('<script src="../Scripts/json2.js"><\/script>'); }</script>

    <script>
        var auditTeam = $.cookie("AuditTeam") == 'true';
        var selectedTab = $.cookie("AuditSelectedTab") ? $.cookie("AuditSelectedTab") : '<%=ManageUPPRM.Catalogs.TaskCategory.All %>';

        $(document).ready(function () {
            $("li[data-action='" + selectedTab + "'] a").click();

            $("#audit-portlet").data('team', auditTeam);

            if (auditTeam) {
                $("#team-label").addClass("active");
                $("#my-label").removeClass("active");
            };

            $(".nav-tabs li").on('shown.bs.tab', function (e) {
                var container = $($(e.target).attr("href"));
                var type = $(this).data('action')
                $.cookie('AuditSelectedTab', type);

                getTasks(container, type);
            });

            $('.reload').on('click', function () {
                $(this).closest('div.portlet').find('.task-widget li.active a').trigger('shown.bs.tab');
                return false;
            });

            $('.my-team-switch input.toggle').on('change', function (event) {
                var myTasks = $(this).val() == "my";
                var team = !myTasks,
                portletContainer = $(this).closest('div.portlet');
                portletContainer.data('team', team);
                portletContainer.find('.task-widget li.active a').trigger('shown.bs.tab');
                $.cookie("AuditTeam", team);
            });

            $('#create-task-button').on('click', function () {
                $('#create-task-modal').modal('show');
                return false;
            });

            $('.task-widget li.active a').trigger('shown.bs.tab');
        });

        function getTasks(container, actionID) {
            var team = $('.my-team-switch').length ? container.closest('div.portlet').data('team') : false;
            $.ajax({
                type: "POST",
                url: "../ManageUpWebService.asmx/GetTasksRows",
                async: true,
                data: JSON.stringify({ category: actionID, team: team, linkToChart: false, audit: true }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    container.find('.loading-container').html('<img src="img/ajax-loader.gif" class="loader-img" />');
                    container.find('.table-container').hide();
                    Metronic.startPageLoading();
                },
                success: function (data) {
                    container.find('img.loader-img').remove();
                    Metronic.stopPageLoading();
                    var table = container.find('table');
                    if (data.d.length == 0) {
                        container.find('.loading-container').html('<h3>There are no tasks</h3>');
                    }
                    else {
                        if (table.hasClass('dataTable')) {
                            table.DataTable().destroy();
                        };

                        table.find('tbody').html(data.d);

                        var columns = table.find('thead tr th').map(function (i, el) {
                            return { "visible": true };
                        });

                        container.find('.tooltips').tooltip();
                        container.find('table').DataTable({
                            "columns": columns,
                            stateSave: true,
                            "stateLoadParams": function (settings, data) {
                                var columns = [];
                                $.each(settings.aoColumns, function (i, el) {
                                    columns.push({ "visible": el.bVisible });
                                });

                                $.each(data.columns, function (i, el) {
                                    el.visible = columns[i].visible;
                                });
                            }
                        });
                        container.find('.table-container').show();
                    };
                }
            });
        };

        function showSelectedSection(section) {
            $('#liTasks ul li a').parent().removeClass('active');
            $('#liTasks ul li a[data-selected="' + section + '"]').parent().addClass('active');

            if (section == 'create') {
                $('#create-task-modal').modal('show');
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
                return false;
            };
        };
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-content-wrapper">
        <div class="page-content">
            <div class="row">
                <div class="portlet light bordered" id='audit-portlet' data-team="false">
                    <div class="portlet-title " style="border: none;">
                        <div class="tabbable-line col-md-9">

                            <ul class="nav nav-tabs home-tabs nav-justified task-widget">

                                <li class="active" data-action="<%=ManageUPPRM.Catalogs.TaskCategory.All %>">
                                    <a href="#UrgentTabContent" data-toggle="tab">All </a>
                                </li>

                                <li data-action="<%=ManageUPPRM.Catalogs.TaskCategory.Urgent %>">
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

                            </ul>
                        </div>
                        <div class="col-md-3 tools text-right">
                            <a href="javascript:;" class="reload"></a>
                            <a href="javascript:;" class="collapse margin-right-10" data-original-title="" title=""></a>
                            <asp:Panel runat="server" ID="TeamMyContainer">
                                <div class="btn-group my-team-switch" data-toggle="buttons">
                                    <label class="btn btn-default active withTooltip" id="my-label" data-original-title="Show the Tasks and Objectives where you are the Assignee (owner)">
                                        <input type="radio" name="myTeam" value="my" class="toggle" />
                                        My
                                    </label>
                                    <label class="btn btn-default withTooltip" id="team-label" data-original-title="Show the Tasks and Objectives where you are assigned as a Viewer. These Tasks and Objectives may belong to users who report to you or members of your project teams and task forces.">
                                        <input type="radio" name="myTeam" value="team" class="toggle" />
                                        Team
                                    </label>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                    <div class="portlet-body" style="position: relative;">
                        <div class="tab-content">
                            <div class="tab-pane active" id="UrgentTabContent">
                                <div class="table-container">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
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

        </div>
    </div>
</asp:Content>
<asp:Content ContentPlaceHolderID="modals" ID="Content3" runat="server">
    <div class="modal fade" id="create-task-modal" tabindex="-1" aria-hidden="true" style="display: none;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                    <h4 class="modal-title">Tasks</h4>
                </div>
                <div class="modal-body">
                    <a class="btn green tooltips" href="<%= Page.ContentLastWrite("/dashjs/addptask.aspx")%>" title="A task that is personal to the owner, view and actionable only by task owner">Personal Task</a>
                    <a class="btn green tooltips" href="<%= Page.ContentLastWrite("/dashjs/addtask.aspx")%>" title="A makeshift task without SQUEEZE points.  It may be assigned, viewed, and actionable by other people">Ad-Hoc Task</a>
                    <a class="btn green tooltips" href="<%= Page.ContentLastWrite("/dashjs/adddtask.aspx")%>" title="A standardized task with SQUEEZE points.  It may be assigned, viewed, and actionable by other people">Template Task</a>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn red" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
