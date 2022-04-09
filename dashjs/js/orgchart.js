(function () {
    $.ajax({
        type: "POST",
        url: "../ManageUPWebService.asmx/GetClientIDAutoLogin",
        async: true,
        data: {},
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (data) {
            if (data.d == 1) {
                 jsPlumb.ready(function () {
        //    var webServiceUrlPrefix = "http://localhost:9991/";
        //  var webServiceUrlPrefix = "http://manageup2.azurewebsites.net/";
        var webServiceUrlPrefix = "../";
        var connectorColor = "gray";
        var department;
        var jsplumbInstance;

        var notificationMasterItemTopOffset = 70;
        var notificationMasterItemLeftOffset = 10;
        var defaultNmMinuteBuffer = 5;

        // jsplumb setup
        jsplumbInstance = jsPlumb.getInstance({
            Connector: ["Bezier", { curviness: 50 }],
            DragOptions: { cursor: "pointer", zIndex: 2000 },
            PaintStyle: { strokeStyle: connectorColor, lineWidth: 2 },
            EndpointStyle: { radius: 9, fillStyle: connectorColor },
            HoverPaintStyle: { strokeStyle: "#ec9f2e" },
            EndpointHoverStyle: { fillStyle: "#ec9f2e" },
            Container: "flowchart"
        });

        // Make sure endpoints aren't detachable via mouse
        jsplumbInstance.importDefaults({
            ConnectionsDetachable: false,
            ReattachConnections: false
        });

        // Define globally accessable function
        window.getDepartment = function (departmentId, minuteBuffer) {
            getDepartment(departmentId, minuteBuffer);
        };

        // Load departments list from service call
        var DTO = { 'username': username };
        var deptid;

        //GetDepartmentForUser

        $.ajax({
            type: "POST",
            async: false,
            url: webServiceUrlPrefix + "ManageUPWebService.asmx/GetDepartmentForUser",
            data: JSON.stringify(DTO),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                deptid = msg.d;
            }
        });

        $('#departmentSelect').on('change', function () {
            getDepartment($(this).val(), defaultNmMinuteBuffer);
            $('#departmentTitle').html($(this).find('option:selected').text().replace(/\(\d+\)/g, ''));
        });

        $.ajax({
            type: "POST",
            url: webServiceUrlPrefix + "OrgChartDataService.asmx/GetDepartments",
            data: JSON.stringify(DTO),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (msg) {
                var items = [];

                $.each(msg.d, function (i, dp) {
                    items.push('<option value="' + dp.DepartmentID + '" >' + dp.DepartmentName + '</option>');
                });

                $('#departmentSelect').append(items.join(''));
                $('#departmentSelect').val(deptid).trigger('change');
            },
            error: function (xhr, ajaxOptions, thrownError) {
                $('#flowchart').html(thrownError);
            }
        });

        $('#flowchart').find('.min-max-button').data('collapsed', false);

        $('#flowchart').on('click', 'a.min-max-button', function (event) {
            var _this = $(event.target);
            var orgContainer = _this.closest('div.orgchartitem');

            var collapsed = orgContainer.data('collapsed');
            var userID = orgContainer.data('userid');

            var itemName = 'flownode_' + userID;

            //console.log('collapsed ' + orgContainer.data('collapsed'));
            orgContainer.data('collapsed', !collapsed);
            collapseExpandElementsAndChilds(itemName, collapsed);

            if (collapsed) {
                orgContainer.find('.min-max-button img').attr('src', 'img/collapse.png');
            }
            else {
                orgContainer.find('.min-max-button img').attr('src', 'img/expand.png');
            };
        });

        var collapseExpandElementsAndChilds = function (itemName, collapse) {
            var orgContainer = $('#' + itemName).closest('div.orgchartitem');
            var endpoints = jsplumbInstance.getEndpoints(itemName);
            $.each(endpoints, function (i, el) {
                if (this.connections.length > 0) {
                    var connection = this.connections[0];
                    if (connection.targetId == itemName) {
                        console.log('collapseExpandElementsAndChilds collapsed ' + orgContainer.data('collapsed'));
                        if (collapse) {
                            if (orgContainer.data('collapsed') != true) {
                                jsplumbInstance.show(connection.sourceId, true);
                                $('#' + connection.sourceId).show();
                                collapseExpandElementsAndChilds(connection.sourceId, collapse);
                            };
                        }
                        else {
                            jsplumbInstance.hide(connection.sourceId, true);
                            $('#' + connection.sourceId).hide();
                            collapseExpandElementsAndChilds(connection.sourceId, collapse);
                        };
                    };
                };
            });
        }

        window.jsplumbInstance = jsplumbInstance;

        function getDepartment(departmentId, minuteBuffer) {
            $.ajax({
                type: "POST",
                url: webServiceUrlPrefix + "OrgChartDataService.asmx/GetOrgChartForDepartmentId",
                data: '{"departmentId":"' + departmentId +
                   '","minuteBuffer":"' + minuteBuffer + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                beforeSend: function () {
                    $('#flowchart').empty()
                    $('#flowchart').isLoading();
                },
                success: function (msg) {
                    department = msg.d;

                    drawChartItemsForDepartment();
                    $('#flowchart').isLoading('hide');
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    // Something bad happened, show error.
                    $('#flowchart').html(thrownError);
                }
            });
        };

        function drawChartItemsForDepartment() {
            // Removes every endpoint, detaches every connection, and clears the
            // event listeners list. Returns jsPlumb instance to its initial state.
            jsplumbInstance.reset();

            if ($.isArray(department.Underlings) && department.Underlings.length > 0) {
                var traverseData = traverse_underlings(department.Underlings);

                var flowChartItemsHtml = traverseData.FlowChartItemsHtml;

                var htmlValues = [];

                for (var index in flowChartItemsHtml) {
                    htmlValues.push(flowChartItemsHtml[index]);
                }

                $('#flowchart').html(htmlValues);

                positionChartItems(traverseData.AllUnderlings);

                //  jsplumbInstance.setSuspendDrawing(true);

                createChartEndpoints(traverseData.ParentChildMap);

                var allOrgchartItems = $(".orgchartitem");

                jsplumbInstance.draggable(
                    allOrgchartItems, { containment: $(".main-container") }
                );

                // Create click handler for dynamically created element
                for (var underlingindex in traverseData.AllUnderlings) {
                    var underling = traverseData.AllUnderlings[underlingindex];

                    var notificationMasterCount = 0;

                    if (!$.isEmptyObject(underling.NotificationMasters)) {
                        notificationMasterCount = underling.NotificationMasters.length;
                    }

                    if (notificationMasterCount > 0) {
                        var userID = underling.UserID;
                        var subItemsClassIdent = ".orgchartsubitem" + userID;

                        // Dynamic click handler
                        // Create wrapper for closure in loop
                        // issue
                        $(subItemsClassIdent).on("click",
                            function (_item) {
                                return function (ev) {
                                    orgChartSubItemClicked($(this), _item);
                                };
                            }(userID)
                        );

                        var newHeight = $("#" + "flownode_" + userID).height() - (notificationMasterItemTopOffset * notificationMasterCount);

                        $("#" + "flownode_" + userID).height(newHeight);
                    }
                };

                // Repaint everything after suspend
                jsplumbInstance.setSuspendDrawing(false, true);

                removeCollapseButtons()
            }
            else {
                $('#flowchart').html("Department has no members");
            }
        }

        var removeCollapseButtons = function () {
            var elements = [];
            var targets = [];

            var connections = jsplumbInstance.getAllConnections();
            $.each(connections.jsPlumb_DefaultScope, function (i, el) {
                elements.push(this.sourceId);
                elements.push(this.targetId);
                targets.push(this.targetId);
            });

            $.each(elements, function (i, el) {
                var element = $('#' + el);

                if ($.inArray(el, targets) == -1) {
                    element.find('.min-max-button').closest('li').remove();
                };
            });
        };

        function createChartEndpoints(parentChildMap) {
            var rootKeys = department.RootUserIDs;

            // declare some common values:
            var arrowCommon = { foldback: 0.7, fillStyle: connectorColor, width: 14 },
                // use three-arg spec to create two different arrows with the common values:
                overlays = [
                    //["Arrow", { location: 0.7, direction: -1 }, arrowCommon],
                    ["Arrow", { location: 0.3, direction: -1 }, arrowCommon]
                ];

            for (var parentKey in parentChildMap) {
                var parentElement = "flownode_" + parentKey;

                for (var subkey in parentChildMap[parentKey]) {
                    var childUser = parentChildMap[parentKey][subkey];
                    var childElement = "flownode_" + childUser.UserID;
                    var isLastChild = $.isEmptyObject(childUser.Underlings);

                    var anchors = "";

                    anchors = isLastChild ? ["Top"] : ["Bottom"];

                    var parentKeyInt = parseInt(parentKey, 10);

                    if ($.inArray(parentKeyInt, rootKeys) != -1) {
                        anchors = ["Top"];
                    }

                    jsplumbInstance.connect({
                        source: childElement,
                        target: parentElement,
                        anchors: anchors,
                        overlays: overlays
                    });
                }
            }
        }

        // Recursive function to traverse hierarchy of users in a department
        function traverse_underlings(underlings, traverseData, parent) {
            if (typeof traverseData === 'undefined') {
                traverseData = new Object();
            }

            if (!traverseData.hasOwnProperty('FlowChartItemsHtml')) {
                traverseData.FlowChartItemsHtml = [];
            }

            if (!traverseData.hasOwnProperty('ParentChildMap')) {
                traverseData.ParentChildMap = [];
            }

            if (!traverseData.hasOwnProperty('AllUnderlings')) {
                traverseData.AllUnderlings = [];
            }

            $.each(underlings, function (i, underling) {
                var isUnderlingAnInnerDepartmentNotificationUserId =
                    $.inArray(underling.UserID, department.InnerDepartmentNotificationUserIds) != -1;

                var doesNmUnderlingHaveUnderlings = false;

                if (isUnderlingAnInnerDepartmentNotificationUserId) {
                    if ($.isEmptyObject(underling.Underlings)) {
                        doesNmUnderlingHaveUnderlings = true;
                    }
                }

                // Does user already exist don't / create html node twice but create the realtionships map
                if (traverseData.FlowChartItemsHtml.hasOwnProperty(underling.UserID)
                    || (isUnderlingAnInnerDepartmentNotificationUserId && doesNmUnderlingHaveUnderlings)
                ) {
                }
                else {
                    traverseData.AllUnderlings.push(underling);
                    traverseData.FlowChartItemsHtml[underling.UserID] = getFlowChartItemHtml(underling);
                }

                if (parent) {
                    if (!(isUnderlingAnInnerDepartmentNotificationUserId && doesNmUnderlingHaveUnderlings)) {
                        if (!traverseData.ParentChildMap.hasOwnProperty(parent.UserID)) {
                            traverseData.ParentChildMap[parent.UserID] = [];
                        }

                        traverseData.ParentChildMap[parent.UserID].push(underling);
                    }
                }

                if ($.isArray(underling.Underlings) && underling.Underlings.length > 0) {
                    traverse_underlings(underling.Underlings, traverseData, underling);
                }
            });

            return traverseData;
        }

        function getFlowChartItemDetailHtml(underling) {
            var fullName = underling.FirstName;

            if (!$.isEmptyObject(underling.LastName)) {
                fullName += " " + underling.LastName;
            }

            var profilePicUrl = "../assets/admin/layout/img/avatar.png";

            if (!$.isEmptyObject(underling.ProfilePicURL)) {
                profilePicUrl = "../imagehandler.ashx?w=150&h=150&file=" + underling.ProfilePicURL;
            }

            var item =
                '<i class="icon-user">' +
                '<img src="' + profilePicUrl + '"></i>' +
                '<div class="thumb_detail">' +
                '<h3>' + fullName + '</h3>' +
                '<p>' + underling.Title + '</p>' +
                '</div>' +
                '<div class="row">' +
                '<div class="filters_users">' +
                '<ul>' +
                '<li><a href="#">' +
                '<img src="img/profile_icon.png" ' +
                'onclick="javascript:ShowMessageModal(\'' + underling.UserID + '\');"></a></li>' +
                '<li><a href="javascript:ShowLoggedStatus(\'' + underling.UserID + '\');">' +
                '<img src="' + underling.AvailabilityImageURL + '"></a></li>' +
                '<li><a href="javascript:ShowSQModal(\'' + underling.UserID + '\');">' +
                '<img src="img/star_icon_small.png"></a></li>' +
                '<li><a href="javascript:void(0)" class="min-max-button" style="font-size: 35px;">' +
                '<img src="img/collapse.png"></a></li>' +
                '</ul>' +
                '</div>' +
                '</div>';

            return item;
        }

        //'<li><a href="javascript:ShowSQModal(\'' + underling.UserID + '\');">' +

        //Creates the user html
        function getFlowChartItemHtml(underling) {
            var notificationMasterCount = 0;
            var item = "";

            if (!$.isEmptyObject(underling.NotificationMasters)) {
                notificationMasterCount = underling.NotificationMasters.length;
            }

            if (notificationMasterCount > 0) {
                item += '<div class="orgchartitem withNotificationMaster"  style="position: absolute; background: transparent; z-index: 2000; border-color : red;  border:0px solid orange" id="flownode_' + underling.UserID + '" data-userid=' + underling.UserID + ' data-collapsed="false" >';

                item += '<div class="window orgchartwithnmitems orgchartsubitem' + underling.UserID + '" style="position: relative; z-index: 1" id="flownode_sub_' + underling.UserID + '">';
                item += getFlowChartItemDetailHtml(underling);
                item += '</div>';

                var top = 0;
                var left = 0;
                var marginbottom = 0;
                var nmZIndex = 1;

                $.each(underling.NotificationMasters, function (i, notificationMaster) {
                    var nmUser = notificationMaster.NotificationToUser;

                    top += -notificationMasterItemTopOffset;
                    left += notificationMasterItemLeftOffset;
                    marginbottom = 0;

                    nmZIndex++;

                    item +=
                    '<div class="window callout-cover-user orgchartsubitem' + underling.UserID + '" style="position:relative;  top: '
                    + top + 'px; margin-bottom: ' + marginbottom + 'px; left: ' + left + 'px; z-index: ' + nmZIndex + '"  id="flownode_'
                    + underling.UserID + '_nm_' + nmUser.UserID + '">';

                    item += getFlowChartItemDetailHtml(nmUser);
                    item += '</div>';
                });

                item += '</div>';
            }
            else {
                item += '<div class="window orgchartitem" style="position: absolute" id="flownode_' + underling.UserID + '" data-userid=' + underling.UserID + ' data-collapsed="false" >';
                item += getFlowChartItemDetailHtml(underling);
                item += '</div>';
            }

            return item;
        }

        function getDepthInfoForRow(row) {
            for (var index in department.DepthInfo) {
                var depthInfo = department.DepthInfo[index];

                if (depthInfo.Row == row) {
                    return depthInfo;
                }
            }

            return null;
        }

        function positionChartItems(allUnderlings) {
            // Start Position flow chart items
            var allunderlingsSortedByDepth = allUnderlings.sort(sortUnderlingsByRowDepth);

            var rowDepth = 0;
            var leftOffSet = 0;
            var depthInfo;
            var newRowDepthInfo = null;
            var heightMatrix = [];
            var topOffset = 0;

            var containerWidth = $("#flowchart").innerWidth();

            var chartItemWidth = 205;
            var colSpaceWidth = 50;
            var rowSpaceHeight = 75;

            var maxHorizontalItemsBeforeScroll = 0;

            if ((chartItemWidth + colSpaceWidth) <= containerWidth) {
                maxHorizontalItemsBeforeScroll = Math.round(containerWidth / (chartItemWidth + colSpaceWidth));
            }

            var currentCol = 1;

            for (var index in allunderlingsSortedByDepth) {
                var flowchartNodeKey = "#flownode_" + allunderlingsSortedByDepth[index].UserID;
                var flowchartNode = $(flowchartNodeKey);
                var newRowDepth = allunderlingsSortedByDepth[index].RowDepth;

                if (newRowDepth != rowDepth) {
                    depthInfo = getDepthInfoForRow(rowDepth);
                    newRowDepthInfo = getDepthInfoForRow(newRowDepth);
                    leftOffSet = 0;
                    currentCol = 1;

                    if (newRowDepth > 1) {
                        var highest = Math.max.apply(null, heightMatrix);

                        topOffset = topOffset + highest + rowSpaceHeight - (notificationMasterItemTopOffset * depthInfo.NotificationMasterMaxDepth);
                        heightMatrix.length = 0;
                    }
                }

                if (newRowDepthInfo.ColumnDepth <= maxHorizontalItemsBeforeScroll) {
                    if (currentCol == 1) {
                        var fullItemWidth;

                        if (newRowDepthInfo.ColumnDepth > 1) {
                            fullItemWidth = (chartItemWidth * newRowDepthInfo.ColumnDepth) + (colSpaceWidth * (newRowDepthInfo.ColumnDepth - 1));
                        }
                        else {
                            fullItemWidth = chartItemWidth + colSpaceWidth;
                        }

                        leftOffSet = (containerWidth / 2) - (fullItemWidth / 2);
                    }
                }

                flowchartNode.css('top', topOffset);
                flowchartNode.css('left', leftOffSet);

                leftOffSet = leftOffSet + chartItemWidth + colSpaceWidth;

                rowDepth = newRowDepth;

                currentCol++;
                heightMatrix.push(flowchartNode.outerHeight(true));
            }
            // End Position flow chart items
        }

        //Custom sort method
        function sortUnderlingsByRowDepth(a, b) {
            var aName = a.RowDepth;
            var bName = b.RowDepth;
            return ((aName < bName) ? -1 : ((aName > bName) ? 1 : 0));
        }

        // Z-Index logic for user substition
        function orgChartSubItemClicked(currentSubWindow, userId) {
            //var currentSubWindow = $(this);

            var indexHighest = 0;

            // more effective to have a class for the div you want to search
            var classId = ".orgchartsubitem" + userId;

            $(classId).each(function () {
                // always use a radix when using parseInt
                var indexCurrent = parseInt($(this).css("zIndex"), 10);

                if (indexCurrent > indexHighest) {
                    indexHighest = indexCurrent;
                }

                // If current is highest and not current
                // element then decrease z-index by one
                // (normalizes sister elments with indentical
                // z-indexes
                if (indexCurrent > 1 && !($(this).is(currentSubWindow)) && indexHighest == indexCurrent) {
                    $(this).css("zIndex", indexHighest - 1);
                }
            });

            currentSubWindow.css("zIndex", indexHighest);
        }
    });
            }
        },
    });
})();