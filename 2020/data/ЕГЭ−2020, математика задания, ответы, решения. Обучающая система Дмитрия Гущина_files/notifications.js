Notifications = function(){
    $('head').append('<style>\
    .notification {margin:0;padding:0; bottom:10px; right:10px; position:fixed; border:none; z-index:11;}\
    .notification_message {border:1px solid #FFD119; background-color:#FFF1BA; border-radius:5px; padding:5px; margin:2px; display:none; position:relative; width:400px}\
    @media screen and (max-width: 768px) {\
        .notification {bottom:0; right:0; left:0; position:fixed; max-height:30%; overflow:auto;}\
        .notification_message {border-radius:0; margin:0; width:100%; box-sizing: border-box;}\
    }\
    </style>');
    var t = this;
    t.showing = false;
    t.user_to = undefined;
    this.div = $('<div class="notification"></div>').appendTo('body');
    if (no_user)
        this.timer_id = setInterval(function(){t.get_data()}, 600000);
    //else
    //    this.timer_id = setInterval(function(){t.get_data()}, 600000);
    this.ttimer_id = setInterval(function(){t.tick()}, 5000);
    this.showed = {};
    t.chat_div = $('<div style="background-color:white; position:fixed; left:10px; bottom:35px; width:300px; height:400px; display:none; border:1px solid grey; border-radius:5px; z-index:11"></div>').appendTo('body');
    //t.get_data()
    t.parse_data(notifications_list);
    
};
Notifications.prototype.parse_data = function(resp){
    var t = this;
    for (var i = 0; i< resp.length; i++)
        t.show_note(resp[i]);
    if (resp.length) {
        register_push();
    }
};
Notifications.prototype.get_data = function(){
    var t = this;
    if (no_user) {
        if (!t.showing) {
            $.get('/notifications?ajax=1&a=get_list', function(resp){
                t.parse_data(resp)
            }, 'json');
        }
    } else {
        $.post('/get_messages?ajax=1&a=get_list', {}, function(resp){
            t.parse_data(resp)
        }, 'json');
    }

};

Notifications.prototype.send = function(user, text, cb){
    var t = this;
    $.post('/get_messages?ajax=1&a=send', {'to':user, 'body':text}, function(resp){
        if (t.user_to)
            t.show_messages_div(t.user_to);
        if (cb !== undefined)
            cb(resp);
    }, 'json');
    
};

Notifications.prototype.show_note = function(item){
    var t = this;
    if (this.showed.hasOwnProperty(item['id'])){
        return;
    }
    if (t.user_to && t.user_to.hasOwnProperty('id') && t.user_to['id'] == item['from']){
        return;
    }
    t.showing = true;
    var idiv = $('<div class="notification_message"></div>');
    if (item.hasOwnProperty('fake')){
        idiv.data('fake', true);
    } else {
        idiv.data('fake', false);
    }
    if (item['from'] == 0){
        idiv.append(
            $('<div style="font-weight:bold;position:absolute; left:5px; top:0px; line-height:18px" class="name"></div>').text(item['from_str']),
            $('<div style="position:absolute; right:30px; top:0px; color:#808080; font-size:10px; line-height:18px"></div>').text(item['creation_time']),
            $('<div style="margin-top: 25px;text-align: left;"></div>').html(item['body']),
            $('<div style="top:0px; right: 5px;position: absolute;font-size: 16px;line-height: 10px; cursor:pointer">x</div>').click(function(){t.showing = false; var td=$(this); if (!td.parent().data('fake')) t.mark_read(td.parent().data('id')); td.parent().fadeOut(); return false;})
        );
        idiv.find('.name').css('color', '#f60');
    }
    else {
        idiv.append(
            $('<div style="font-weight:bold;position:absolute; left:5px; top:0px; line-height:18px" class="name"></div>').text(item['from_str']),
            $('<div style="position:absolute; right:30px; top:0px; color:#808080; font-size:10px; line-height:18px"></div>').text(item['creation_time']),
            $('<div style="margin-top: 25px;white-space:pre-line;text-align: left;"></div>').text(item['body']),
            $('<div style="top:0px; right: 5px;position: absolute;font-size: 16px;line-height: 10px; cursor:pointer">x</div>').click(function(){t.showing = false; var td=$(this); if (!td.parent().data('fake')) t.mark_read(td.parent().data('id')); td.parent().fadeOut(); return false;})
        );
        idiv.click(function(){
            t.show_messages_div($(this).data('user'));
            var td=$(this); if (!td.data('fake')) t.mark_read(td.data('id')); td.fadeOut(); return true;
        }).data('user', {'id':item['from'], 'name':item['from_str']});
    }
    idiv.data('id', item['id']).appendTo(this.div).fadeIn();
    this.showed[item['id']] = 1;
};
Notifications.prototype.mark_read = function(id){
    $.post('/get_messages?ajax=1&a=mark_read&id='+id, {}, function(){}, 'html');

};

Notifications.prototype.show_chat = function(){
    var t = this;
    t.chat_div.show();
    t.user_to = undefined;
    $.post('/get_messages?ajax=1&a=users_list', {}, function(resp){t.show_user_list(resp)}, 'json');
};
Notifications.prototype.show_user_list = function(data){
    var t = this;
    t.chat_div.empty();
    t.chat_div.append($('<div style="background-color:#FFF1BA; font-weight:bold; padding:10px; border-bottom:1px solid #FFD119; border-radius:5px 5px 0 0; margin:0"></div>').text('Список контактов'));
    var div = $('<div style="position:absolute; top:30px; left:0px; right:0px; bottom:5px; overflow-y:auto; overflow-x:visible"></div>');
    div.append(div, $('<div style="width:100%; border-bottom:1px solid grey; padding:5px 0; cursor:pointer;color:#a0a0a0; text-align:center"> + Добавить пользователя</div>').click(function(event){
        var td = $(this);
        td.unbind(event);
        td.empty();
        td.append('E-mail: <input type="text" style="width:150px"> ');
        td.append($('<input type="button" value="Добавить">').click(function(){
            t.send(td.find('input[type=text]').val()+'.', 'Пользователь добавил Вас в свой список контактов', function(resp){if (resp) t.show_messages_div(resp); else t.show_chat();});
        }));
    }));
    for (var i=0; i<data.length; i++){
        div.append(
            $('<div style="width:100%; border-bottom:1px solid grey; padding:5px 0; cursor:pointer; position:relative"></div>').append(
                $('<span style="margin:5px;"></span>').text(data[i]['name']),
                data[i]['id']==0?'':$('<div style="position:absolute; right:10px; top:0; cursor:pointer">x</div>').click(function(e){
                    var tt = $(this);
                    if (confirm('Удалить пользователя из списка контактов?')) {
                        $.post('/get_messages?a=remove_user&ajax=1', {'id': tt.parent().data('id')['id']}, function(){tt.parent().remove();});
                    }
                    e.stopPropagation();
                })
            ).data('id', data[i]).click(function(){t.show_messages_div($(this).data('id'))})
        );
    }
    t.chat_div.append(div, $('<div style="cursor:pointer; position:absolute; top:5px; right:10px">x</div>').click(function(){t.close_chat()}));
};
Notifications.prototype.show_messages_div = function(user_to){
    var t = this;
    t.chat_div.show();
    t.chat_div.empty();
    $.post('/get_messages?ajax=1&a=get_messages', {'id':user_to['id']}, function(resp){t.user_to = user_to; t.show_messages(resp)}, 'json');
};
Notifications.prototype.show_messages = function(data){
    var t = this;
    t.chat_div.empty();
    t.chat_div.append($('<div style="background-color:#FFF1BA; font-weight:bold; padding:10px; border-bottom:1px solid #FFD119; border-radius:5px 5px 0 0; margin:0; height:10px"></div>').text(t.user_to['name']));
    t.mess_div=$('<div style="position:absolute; top:30px; left:0px; right:0px; bottom:35px; overflow-y:auto; overflow-x:visible; margin:0 3px"></div>');
    var div = t.mess_div;
    t.chat_div.append(div);
    t.renew_messages(data);
    t.chat_div.append(
        t.user_to['id'] == 0?'':$('<textarea style="position:absolute; bottom:5px; left:5px; width:285px; height:20px; "></textarea>').autoResize({append:'&nbsp;'}).keyup(function(e){code = e.keyCode || e.which; if (e.ctrlKey && e.keyCode == 13) {t.send(t.user_to['id'], $(this).val()); $(this).val('');} else if (code==13){}
}),
        t.user_to['id'] == 0?'':$('<img src="/img/arr.png" style="position:absolute; bottom:8px; right:8px;" title="Ctrl + Enter &mdash; отправить. Enter &mdash; перевод строки. ">').click(function(e){t.send(t.user_to['id'], $(this).prev().val()); $(this).prev().val(''); return false}),
        $('<div style="cursor:pointer; position:absolute; top:5px; right:10px">x</div>').click(function(){t.show_chat()})
    );
};

Notifications.prototype.renew_messages = function(data){
    var t = this;
    var div=t.mess_div;
    if (div.data('count') == data.length){
        return;
    }
    div.data('count', data.length);
    div.empty()
    for (var i=0; i<data.length; i++){
        div.append(
            $('<div style="width:100%; border-bottom:1px solid grey; padding:5px 0; position:relative"></div>').append(
                $('<div style="position:absolute; right:5px; top:5px; font-size:8px; color:#808080"></div>').text(data[i]['creation_time']), 
                $('<span style="margin:5px;font-weight:bold"></span>').text(data[i]['from_str']), 
                '<br>', 
                data[i]['from']==0?$('<span style="margin:5px;"></span>').html(data[i]['body']):$('<span style="margin:5px;white-space:pre-line"></span>').text(data[i]['body'])
            )
        );
    }
    div.scrollTop(div.prop("scrollHeight"));
};
Notifications.prototype.close_chat = function(){
    var t = this;
    t.chat_div.hide();
    t.user_to = undefined;
};
Notifications.prototype.tick = function(){
    var t=this;
    if (!t.user_to){
        return
    }
    $.post('/get_messages?ajax=1&a=get_messages', {'id':t.user_to['id']}, function(resp){t.renew_messages(resp)}, 'json');
};

notifications = new Notifications();
