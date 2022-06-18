export interface spawnObject {
  coords: {
    x: number,
    y: number,
    z: number,
  }
  id: number
  model: string
  name: string
  options: { [key: string]: any }
  type: string
}

export interface creatableObject {
  name: string
  object: string
  distance: number
  type: string
}

export interface loadMessageData {
  action: string
  objects: { [key: string]: boolean }
  objectTypes: Array<string>
  spawnedObjects: { [key: string]: spawnObject }
}

export interface deleteMessageData {
  action: string
  id: number
}

export interface createdMessageData {
  action: string
  newSpawnedObject: spawnObject
}