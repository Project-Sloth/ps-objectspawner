<script lang="ts">
  import Button from '../../components/atoms/button.svelte';
  import ObjectStore from '../../stores/objectStore';
  import type { spawnObject } from "../../types/types";
  import { fetchNui } from '../../utils/eventHandler';

  let { spawnedObjectList } = ObjectStore;
  let activeID: number = 0;
  let activeRecord: spawnObject = null;

  function handleItemClick(record: spawnObject) {
    activeRecord = record;
    activeID = record.id;
  }

  function handleDelete() {
    fetchNui('delete', { id: activeRecord.id });
    $spawnedObjectList = $spawnedObjectList.filter(item => item.id !== activeID);
  }

  function handleGoto() {
    fetchNui('tpTo', { coords: activeRecord.coords });
  }
</script>

<div class="min-h-94 flex flex-col gap-2 text-center">
  <div class="grid grid-cols-3">
    <div class="text-xl font-bold">
      <p class="text-xl font-bold">Name</p>
    </div>
    <div>
      <p class="text-xl font-bold">Object</p>
    </div>
    <div>
      <p class="text-xl font-bold">Cords (x,y,z)</p>
    </div>
  </div>
  <div class="block h-82 overflow-y-auto bg-[#292929] select-none">
    {#each $spawnedObjectList as record (record.id)}
      <div class="grid grid-cols-3 bg-dark-200 py-1 cursor-pointer {activeID == record.id ? "active" : ""} hover"
        on:click={() => handleItemClick(record)}>
        <div>
          <p>{record.name}</p>
        </div>
        <div>
          <p class="truncate">{record.model}</p>
        </div>
        <div>
          <p>( {record.coords.x.toFixed(2)}, {record.coords.y.toFixed(2)}, {record.coords.z.toFixed(2)} )</p>
        </div>
      </div>
    {/each}
  </div>
  <div class="flex flex-row justify-between mt-4">
    <Button name={"Delete"} buttonClass="ml-5 w-35" on:click={() => handleDelete()}/>
    <Button name={"GOTO"} buttonClass="mr-5 w-35" on:click={() => handleGoto()}/>
  </div>
</div>

<style>
  .active {
    color: black;
    background-color: var(--ps-primary) !important;
  }
  .hover:hover {
    background-color: var(--ps-primary-hover);
  }
</style>