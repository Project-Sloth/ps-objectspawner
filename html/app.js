const { ref, onBeforeUnmount } = Vue

let ObjectList = []

const menu = {
    setup() {
        const objectOptions = ref(ObjectList)
        return {
            model: ref(null),
            objectOptions,
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
        }
    },
    data() {
        return {
            CurrentObject: null,
        };
    },
    methods: {
        UpdateObject: function(object) {
            this.CurrentObject = object
        },
        SpawnObject: function() {
            $.post(`https://GetCurrentResourceName()/spawn`, JSON.stringify({object: this.CurrentObject }));
        },
        UpdateObjectList: function(ObjectList) {
            ObjectList = ObjectList
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
    $.post(`https://GetCurrentResourceName()/close`);
}