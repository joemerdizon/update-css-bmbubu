//browser detection
var isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;
var isFirefox = typeof InstallTrigger !== 'undefined';   // Firefox 1.0+
var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
// At least Safari 3+: "[object HTMLElementConstructor]"
var isChrome = !!window.chrome && !isOpera;              // Chrome 1+
var isIE = /*@cc_on!@*/false || !!document.d;

var serializeArrayToJSON = function (array) {
    var result = '{';

    $.each(array, function (i, el) {
        result += '"' + el.name + '": "' + el.value + '", ';
    });

    result = result.substr(0, result.length - 2);
    return JSON.stringify(jQuery.parseJSON(result += '}'));
};

var convertStringtoDate = function (date) {
    if (date == undefined) {
        return undefined;
    };

    return new Date(date);
};

$(document).ready(function () {
    $('body').on('click', 'a.open-full-screen-modal', openFullScreenModal);

    $('a.show-loading').on('click', showLoadingScreen);

    $('body').on('click', 'a.open-new-window', function () {
        window.open($(this).prop('href'), '_blank');
        return false;
    });

    $('body').on('click', 'a.expand-collapse-container', expandCollapseContainer);

    $('.with-summernote').each(function (i, el) {
        applySummernote($(el));
    });

    applyCollapsible();

    $('body').on('shown.bs.modal', '.modal', adjustModalHeightAndAddScrollBar);

    applyTooltip($('.withTooltip'));

    $('body').on('click', '.help-video', function () {
        $('#help-video-modal iframe').attr('src', 'https://player.vimeo.com/video/' + $(this).data('videoid'));
        $('#help-video-modal').modal('show');

        return false;
    });

    $('#help-video-modal').on('hidden.bs.modal', function () { $(this).find('iframe').attr('src', ''); });

    $(".not-seen").hover(function () {
        $(this).pulsate("destroy");
    });

    scrollToHashtag();
    truncateFields();
});

var applyTooltip = function (selector) {
    if ($('body').tooltip != undefined && selector.length > 0) {
        selector.tooltip({ placement: 'bottom', container: 'body' });
    };
};

var applyCollapsible = function () {
    $('.collapsible-trigger').on('click', function (el) {
        var target = $($(this).attr('href'));
        if ($(this).find('i').hasClass('icon-chevron-up')) {
            target.collapse('hide');
            $(this).find('i').removeClass('icon-chevron-up').addClass('icon-chevron-down');
        } else {
            target.collapse('show');
            $(this).find('i').addClass('icon-chevron-up').removeClass('icon-chevron-down');
        };

        return false;
    });
};

var showSuccessMsj = function () {
    var $form = $('form');
    var msg = $form.find('#successMsj');
    if (msg.val() != '') {
        $form.find('#success-msg').text(msg.val()).show('fast');
        setTimeout(function () {
            $form.find('#success-msg').hide('fast');
            msg.val('');
        }, 5000);
    };
};

var initializeDatepickers = function (container) {
    container.find('.with-datepicker').datepicker({
        beforeShow: function () {
            container.find('#ui-datepicker-div').addClass('custom-datepicker');
        }
    });
    container.find('.with-datepicker').siblings('.show-calendar').on('click', function () {
        container.find(this).siblings('.with-datepicker').datepicker("show");
    });
};

var safeJoin = function (array) {
    if (!array) {
        return "";
    };

    if (typeof (array) == 'string') {
        return array;
    };

    return array.join();
};

var safeReplace = function (element, regEx, replaceWith) {
    if (!!element) {
        return element.replace(regEx, replaceWith);
    };

    return '';
};

if (typeof String.prototype.startsWith != 'function') {
    String.prototype.startsWith = function (str) {
        return this.slice(0, str.length) == str;
    };
};

function getYoutubeId(url) {
    var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    var match = url.match(regExp);

    if (match && match[2].length == 11) {
        return match[2];
    } else {
        return 'error';
    }
};

var resolveHost = function () {
    return window.location.protocol + "//" + window.location.host;
};

var isUndefined = function (variable) {
    return (typeof variable === 'undefined');
};

function ShowDocumentURL(url) {
    if (isUndefined(url)) {
        return;
    }

    if (url.indexOf('youtube') > -1 || url.indexOf('youtu.be') > -1) {
        ShowVideo("//www.youtube.com/embed/" + getYoutubeId(url));
        return;
    };

    var vimeoMatch = url.match(/(?:https?:\/\/)?(?:www\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|)(\d+)(?:$|\/|\?)/);
    if (vimeoMatch != null) {
        ShowVimeoVideo('https://player.vimeo.com/video/' + vimeoMatch[3])
        return;
    };

    //TODO picture implementation

    if (!url.startsWith("http")) {
        url = 'http://' + url;
    };

    var win = window.open(url, '_blank');
};

function openFullScreenModal() {
    var name = $(this).data('name'),
        url = $(this).attr('href'),
        tabid = $(this).data('tabid'),
        fullScreenModal = $('#full-screen-modal');

    var iframe = fullScreenModal.find('iframe');

    fullScreenModal.find('.modal-title').text(name);

    iframe.load(function () {
        iframe.show().parent().show();
        autoResizeIframeContent(iframe[0]);
        Metronic.unblockUI('#full-screen-modal .modal-content');
    });

    iframe.parent().hide();

    fullScreenModal.on('shown.bs.modal', function () {
        fullScreenModal.find('.modal-body').show();
        Metronic.blockUI({ target: '#full-screen-modal .modal-content', cenrerY: true, animate: true });
        iframe.prop('src', url);
    });


    fullScreenModal.on('hidden.bs.modal', function () {
        iframe.prop('src', "");
    });

    fullScreenModal.modal('show');
    return false;
};

function loadIframeContent(tabid, container) {
    $('#full-screen-modal').find('#iframe-content').tmpl().appendTo(container);
};

function autoResizeIframeContent(iframe) {
    iframe.height = window.innerHeight - 155 + "px";
};

function applyTooltipIfTextIsTooLong(el, maxChar, tooltipContainer) {
    if (el.length == 0) {
        return;
    };

    var originalText = el.text();

    if (!!originalText) {
        if (originalText.length > maxChar) {
            el.text(originalText.substring(0, maxChar) + '...');
        };

        el.tooltip({ placement: 'bottom', container: tooltipContainer, title: originalText });
    };
};

function inIframe() {
    try {
        return window.self !== window.top;
    } catch (e) {
        return true;
    };
};

var ShowWorkingModal = function () {
    showLoadingScreen();
};

var showLoadingScreen = function () {
    Metronic.blockUI();
};

var CloseWorkingModal = function () {
    closeLoadingScreen();
};

var closeLoadingScreen = function () {
    Metronic.unblockUI();
};

var inArrayWithCondition = function (list, condition) {
    var resultElement;
    $.each(list, function (i, el) {
        if (condition(el)) {
            resultElement = el;
            return;
        };
    });

    return resultElement;
};

var removeFromArrayWithCondition = function (list, condition) {
    $.each(list, function (i, el) {
        if (condition(el)) {
            list.splice(i, 1);
            return false;
        };
    });

    return list;
};

var hideRowIfContentIsEmpty = function (table) {
    table.find('tbody tr').each(function (i, el) {
        if (hasNoContent($(el).find('td:last'))) {
            $(el).hide();
        };
    });
};

var hasNoContent = function (el) {
    return !el.find('input, textarea').length && /^(<[^>]*>|<\/[^>]*>|<[^>]*\/>|\s)*$/.test(el.html());
};


var getValueOrNull = function (selector) {

    var value = selector.val();

    if (value == '' || value == undefined) {
        value = null;
    }

    return value;
};

var showErrorMsgs = function (container, errors) {
    showValidationError('', errors, container);
};

var showValidationError = function (msg, list, container) {
    showMsg(msg, list, container, 'alert-danger error-container');
};

var showSuccessMsg = function (msg, list, container) {
    showMsg(msg, list, container, 'alert-success success-container');
};

var showWarningMsg = function (msg, list, container) {
    showMsg(msg, list, container, 'alert-warning warning-container');
};

var showMsg = function (msg, list, container, alertType) {
    if (container == undefined || $(container).length == 0) {
        container = $('.form-body');
    }
    else {
        container = $(container);
    }

    if (container.find('.form-body').length > 0) {
        container = container.find('.form-body');
    };

    var msgList = '';
    if (!!list) {
        $.each(list, function (i, el) {
            msgList += '<li><p class="marL10">' + el + '</p></li>';
        });
    };

    if (msg != '' || msgList != '') {
        var error = { title: msg, list: msgList };
        var alert = $('#msg-tmpl').tmpl(error);
        alert.addClass(alertType);
        container.prepend(alert);
    };
};

var useDashInstedOfEmptyContent = function () {
    $('p.form-control-static').each(function (i, el) {
        if ($(el).text() == '') {
            $(el).text('-');
        };
    })
};

var adjustModalHeightAndAddScrollBar = function () {
    var currentModal = $('.modal:visible');

    var heightMargin = currentModal.data('heightmargin');
    if (!heightMargin) {
        heightMargin = 0;
    };

    var maxHeight = window.innerHeight - 60 - currentModal.find('.modal-header').outerHeight() - currentModal.find('.modal-footer').outerHeight() - heightMargin;

    if (maxHeight < currentModal.find('.modal-body').outerHeight()) {
        currentModal.find('.modal-body').slimScroll({
            allowPageScroll: false, // allow page scroll when the element scroll is ended
            size: '9px',
            color: '#bbb',
            railColor: '#eaeaea',
            position: 'right',
            height: maxHeight + 'px',
            alwaysVisible: true,
            railVisible: true,
            disableFadeOut: true
        }).focus();
    };
};

/// <summary>
/// Ajax wrapper handling the page block based on options.blockTarget parameter, if it's not here it's going to block the entire page. options.Url is required
/// </summary>
var callWebService = function (options, avoidLoading) {
    var beforeSendTarget = { zIndex: 2147483646 }, //We add the maximum value of zIndex to be sure to block even modals if a target is not selected
        overridenOptions = {},
        defaultOptions = {
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
        };

    if (options.blockTarget) beforeSendTarget = { target: options.blockTarget };

    if (!avoidLoading) {
        overridenOptions.beforeSend = function () {
            Metronic.blockUI(beforeSendTarget);
            if (isFunction(options.beforeSend)) options.beforeSend();
        };

        overridenOptions.success = function (data) {
            if (options.blockTarget) Metronic.unblockUI(options.blockTarget); else Metronic.unblockUI();
            if (isFunction(options.success)) options.success(data);
        };
    };

    var ajaxOptions = $.extend({}, defaultOptions, options, overridenOptions);

    $.ajax(ajaxOptions);
};

var call = function (url, data, callbackSuccess, callbackError) {
    callWebService({
        url: url,
        data: data,
        success: callbackSuccess,
        error: callbackError
    });
};

function isFunction(functionToCheck) {
    var getType = {};
    return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
}

function showToastNotification(msg, title) {
    toastr.options = {
        closeButton: true,
        debug: false,
        positionClass: "toast-top-right",
        onclick: null,
        showDuration: "1000",
        hideDuration: "1000",
        timeOut: "5000",
        extendedTimeOut: "1000",
        showEasing: "swing",
        hideEasing: "linear",
        showMethod: "fadeIn",
        hideMethod: "fadeOut"
    };

    toastr['success'](msg, title);
};

function expandCollapseContainer(e) {
    var container = $(e.target).closest('.portlet');
    container.find('.expand,.collapse').trigger('click');
    return false;
};


function expandContainer(container) {
    var container = container.closest('.portlet');
    container.find('.expand').trigger('click');
    return false;
};


var SignatureButton = function (context) {
    var ui = $.summernote.ui;

    // create button
    var button = ui.button({
        contents: '<div id="add-signature-button" data-title="Add a signature field"><i class="fa fa-pencil-square-o"/> Signature<div>',
        click: function () {
            var editor = $(this).closest('.note-editor');
            var textarea = editor.siblings('textarea');
            var selection = document.getSelection();
            var anchorNode = selection.anchorNode;
            var anchorOffset = selection.anchorOffset;
            var focusNode = selection.focusNode;
            var focusOffset = selection.focusOffset;

            var globalResult = false;

            var prompt = bootbox.prompt("Choose a name", function (result) {
                if (result !== null) {
                    if (result.trim() != "") {
                        globalResult = result;
                    } else {
                        bootbox.alert("Please enter a valid name");
                    }
                }
            });

            prompt.on("hidden.bs.modal", function () {
                if (globalResult) {
                    var node = document.createElement('div');

                    node.innerHTML =
			            "<div class='clearfix'>\
				            <br />\
			            </div>\
                        <div class='signature-container' contenteditable='false'>\
                            <div class='col-sm-6'>\
                                <div class='signature-wrapper'>\
                                    <div class='signature-line'></div>\
                                    <label class='signature-label'>" + globalResult + "</label>\
                                </div>\
                                <div class='clearfix'></div>\
                            </div>\
                            <div class='col-sm-6'>\
                                <div class='signature-wrapper'>\
                                    <div class='signature-line'></div>\
                                    <label class='signature-label'>Date</label>\
                                </div>\
                            </div>\
                        </div>\
                        <div class='clearfix'>\
				            <br />\
			            </div>";

                    textarea.summernote('focus');

                    //Reset caret position to where it was
                    if ($.contains(editor[0], anchorNode)) {
                        selection.collapse(anchorNode, anchorOffset);
                        selection.extend(focusNode, focusOffset);
                    }

                    textarea.summernote('insertNode', node);

                    globalResult = false;
                }
            });
            
        }
    });

    return button.render();   // return button as jquery object 
}

function applySummernote(element, hint, placeholder, height) {
    var toolbar = [
        ['style', ['style']],
        ['font', ['bold', 'italic', 'underline', 'superscript', 'subscript', 'strikethrough', 'clear']],
        ['fontname', ['fontname']],
        ['color', ['color']],
        //['para', ['ul', 'ol', 'paragraph']], TODO: can't be added because the default styles for these elements are different
        ['height', ['height']],
        ['insert', ['link']],
        ['help', ['help']]
    ];

    var buttons = {};

    if (element.hasClass('with-signature')) {
        toolbar.push(['signatureButton', ['signature']]);

        buttons = {
            signature: SignatureButton
        }
    };

    element.summernote({
        height: height ? height : 200,
        toolbar: toolbar,
        buttons: buttons,
        hint: hint,
        placeholder: placeholder
        
    });
}

scrollToElement = function (element) {
    if (element) {
        $('html, body').animate({
            scrollTop: element.offset().top - 98 //98 is the height of the header
        }, 500);
    }
}

scrollToHashtag = function () {
    if (window.location.hash) {
        scrollToElement($(window.location.hash));
    }
};

truncateFields = function () {
    $('.truncate-field').each(function (i, el) {
        el = $(el);
        var maxChar = el.data('maxChar') ? el.data('maxChar') : 20;
        var container = el.data('container') ? el.data('container') : 'body';

        applyTooltipIfTextIsTooLong(el, maxChar, container);
    });
}

isNullOrWhiteSpace = function(input) {

    if (typeof input === 'undefined' || input == null) return true;

    return input.replace(/\s/g, '').length < 1;
}