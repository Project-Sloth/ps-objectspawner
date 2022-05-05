const { ref, onBeforeUnmount } = Vue

let ObjectList = []
let ObjectTypes = []

const menu = {
    setup() {
        const objectOptions = ref(ObjectList)
        const typeOptions = ref(ObjectTypes)
        return {
            model: ref(null),
            types: ref(null),
            objectOptions,
            typeOptions,
            filterFn (val, update) {
                if (val === '') {
                    update(() => {
                        objectOptions.value = ObjectList
                    })
                return
                }
                update(() => {
                    const needle = val.toLowerCase()
                    objectOptions.value = ObjectList.filter(v => v.toLowerCase().indexOf(needle) > -1)
                })
            },
            typeFilter (val, update) {
                if (val === '') {
                    update(() => {
                        typeOptions.value = ObjectTypes
                    })
                return
                }
                update(() => {
                    const needle = val.toLowerCase()
                    typeOptions.value = ObjectTypes.filter(v => v.toLowerCase().indexOf(needle) > -1)
                })
            },
        }
    },
    data() {
        return {
            CurrentObject: null,
            CurrentType: null,
            RenderDistance: 15.0,
        };
    },
    methods: {
        UpdateObject: function(object) {
            this.CurrentObject = object
        },
        SpawnObject: function() {
            $.post(`https://${GetParentResourceName()}/spawn`, JSON.stringify({object: this.CurrentObject, type: this.CurrentType, distance: this.RenderDistance }));
            closeMenu()
        },
        UpdateObjectList: function(ObjectList) {
            ObjectList = ObjectList
        },
        ObjectType: function(type) {
            this.CurrentType = type
        },
        SetRenderDistance: function(distance) {
            this.RenderDistance = distance
        }
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            if (event.data.action === "open") {
                $(".container").fadeIn(150);
            } else if (event.data.action === "load") {
                let temp = []
                $.each(event.data.objects, function(i, v) {
                    if (v == true ) {
                        temp.push(i)
                    }
                });
                ObjectList = temp
                $(".container").fadeIn(150);
            }
        });
    },
}

const app = Vue.createApp(menu);
app.use(Quasar);
app.mount(".container");

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        closeMenu()
    } 
};
  
function closeMenu() {
    $(".container").fadeOut(150);
    $.post(`https://${GetParentResourceName()}/close`);
}