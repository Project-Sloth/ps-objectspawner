import { writable } from 'svelte/store'
import { fetchNui } from '../utils/eventHandler';

interface propObjectStateType {
  currentObject: string
  currentType: string
  isOpen: boolean
  objectList: Array<{ value: string }>
  objectTypes: Array<{ value: string }>
  renderDistance: number
}

const store = () => {

  const propObjectState: propObjectStateType = {
    currentObject: null,
    currentType: null,
    isOpen: false,
    renderDistance: 15,
    objectList: [],
    objectTypes: [],
  };

  const { subscribe, set, update } = writable(propObjectState);

  const methods = {
    closeMenu() {
      update(state => {
        state.isOpen = false;
        return state;
      });
      fetchNui('close');
    },
    handleKeyUp(data) {
      if (data.key == "Escape") {
        methods.closeMenu()
      }
    },
    receiveOpenMessage() {
      update(state => {
        state.isOpen = true;
        return state;
      });
    },
    receiveLoadMessage(data) {
      let objects: Array<{ value: string }> = [];
      let objectTypes: Array<{ value: string }> = [];

      for (const [key, value] of Object.entries(data.objects)) {
        if (value) {
          objects.push({ value: key });
        }
      }

      for (const name of data.objectTypes) {
        objectTypes.push({ value: name as string });
      }
      
      update(state => {
        state.objectList = objects;
        state.objectTypes = objectTypes;
        state.isOpen = true;
        return state;
      });
    },
    setRenderDisable(value) {
      update(state => {
        state.renderDistance = value;
        return state;
      })
    },
    setObject(value) {
      update(state => {
        state.currentObject = value;
        return state;
      })
    },
    setObjectType(value) {
      update(state => {
        state.currentType = value;
        return state;
      })
    },
    spawnObject() {
      update(state => {
        fetchNui("spawn", {
          object: state.currentObject,
          type: state.currentType,
          distance: state.renderDistance,
        })
        methods.closeMenu()
        return state;
      })
    },
  };

  return {
    subscribe,
    set,
    update,
    ...methods
  }
}

export default store();