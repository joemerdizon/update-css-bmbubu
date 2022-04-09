function closeTab() {
    var nodeId = $(this).data('nodeid'),
        container = $(this).closest('.dynicamic-tab-container');

    container.find('#li_' + nodeId).remove();
    container.find('#tab-' + nodeId).remove();

    if (container.find('.dynamic-tabs li.active').length == 0) {
        container.find('.dynamic-tabs li:first a').trigger('click');
    };

    if (container.find('.dynamic-tabs li').length == 0) {
        container.closest('.modal').modal('hide');
    };
};

function addTab(container, nodeId, nodeName, loadContentTab, openTabAlreadyLoaded) {
    var tab = container.find('.dynamic-tabs');

    var link = container.find('#' + nodeId + '-tab');

    if (link.length == 0) {
        var node = document.createElement("LI");
        node.id = 'li_' + nodeId;
        node.class = 'tabNew';

        //link.data-toggle = "tab"

        var textnode = document.createTextNode(nodeName);
        var textnodeClose = document.createTextNode('close');

        //creating link
        link = document.createElement("A");
        link.setAttribute('data-toggle', 'tab');
        link.setAttribute('data-nodeid', nodeId);
        link.setAttribute('href', '#tab-' + nodeId);
        link.id = nodeId + '-tab';
        link.appendChild(textnode);

        $(link).on('click', openTabAlreadyLoaded);

        //creating close button
        var linkClose = document.createElement("I");
        linkClose.setAttribute('data-nodeid', nodeId);
        linkClose.setAttribute('class', 'icon-remove clickable marL10');
        linkClose.setAttribute('width', '16px');

        link.appendChild(linkClose);
        $(linkClose).on('click', closeTab);

        node.appendChild(link);
        tab[0].appendChild(node);

        var textnode2 = document.createTextNode(nodeId);

        var tabContent = container.find('.tab-content')[0];
        var div = document.createElement("DIV");
        div.id = 'tab-' + nodeId;
        div.setAttribute('class', 'tab-pane fade in');

        var tabCl = loadContentTab(nodeId, div);

        tabContent.appendChild(div);
    };

    $(link).trigger('click');
};

