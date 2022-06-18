import { writable } from 'svelte/store'
import type { Writable } from 'svelte/store';
import { fetchNui } from '../utils/eventHandler';
import type { creatableObject, createdMessageData, deleteMessageData, loadMessageData, spawnObject } from '../types/types';

interface propObjectStateType {
  isOpen: Writable<boolean>
  objectList: Writable<Array<{ value: string }>>
  objectTypes: Writable<Array<{ value: string }>>
  spawnedObjectList: Writable<Array<spawnObject>>
}

const store = () => {

  const propObjectState: propObjectStateType = {
    isOpen: writable(false),
    objectList: writable([]),
    objectTypes: writable([]),
    spawnedObjectList: writable([]),
  };

  const methods = {
    closeMenu() {
      propObjectState.isOpen.set(false);
      fetchNui('close');
    },
    handleKeyUp(data) {
      if (data.key == "Escape") {
        methods.closeMenu()
      }
    },
    receiveOpenMessage() {
      propObjectState.isOpen.set(true);
    },
    receiveCreatedMessage(data: createdMessageData) {
      propObjectState.spawnedObjectList.update((list) => {
        list = [...list, data.newSpawnedObject];
        return list;
      })
    },
    receiveDeleteMessage(data: deleteMessageData) {
      propObjectState.spawnedObjectList.update((objectList) => {
        return objectList.filter((item) => item.id != data.id);
      })
    },
    receiveLoadMessage(data: loadMessageData) {
      let objects: Array<{ value: string }> = [];
      let objectTypes: Array<{ value: string }> = [];
      let spawnedObjectList: Array<spawnObject> = [];

      for (const [key, value] of Object.entries(data.objects)) {
        if (value) {
          objects.push({ value: key });
        }
      }

      for (const name of data.objectTypes) {
        objectTypes.push({ value: name as string });
      }

      for (const item of Object.values(data.spawnedObjects)) {
        spawnedObjectList.push(item);
      }
      
      propObjectState.isOpen.set(true);
      propObjectState.objectList.set(objects);
      propObjectState.objectTypes.set(objectTypes);
      propObjectState.spawnedObjectList.set(spawnedObjectList || []);
    },
    spawnObject(objectData: creatableObject) {
      propObjectState.isOpen.set(false);
      fetchNui("spawn", {
        name: objectData.name,
        object: objectData.object,
        type: objectData.type,
        distance: objectData.distance,
      })
    },
  };

  return {
    ...propObjectState,
    ...methods
  }
}

export default store();