<script lang="ts">
  import Button from '../../components/atoms/button.svelte';

  interface spawnObj {
    id: number
    name: string
    cords: string
  }

  let activeName: string = "";
  let activeRecord: spawnObj = null;

  let list: Array<spawnObj> = [
    {id: 1, name: "ballon", cords:"10,10,10"},
    {id: 2, name: "ballon1", cords:"10,10,10"},
    {id: 3, name: "ballon2", cords:"10,10,10"},
    {id: 4, name: "ballon3", cords:"10,10,10"},
    {id: 5, name: "ballon4", cords:"10,10,10"},
    {id: 6, name: "ballon5", cords:"10,10,10"},
    {id: 7, name: "ballon6", cords:"10,10,10"},
  ];

  function handleItemClick(record) {
    activeRecord = record;
    activeName = record.name;
  }

  function handleDelete() {
    list = list.filter(item => item.name !== activeName)
  }

  function handleGoto() {

  }
</script>

<div class="min-h-84 flex flex-col gap-2 text-center">
  <div class="flex flex-row">
    <div class="w-1/2">
      <p class="text-xl font-bold">Name</p>
    </div>
    <div class="w-1/2">
      <p class="text-xl font-bold">Cords</p>
    </div>
  </div>
  <div class="block h-59 overflow-y-auto bg-[#292929] select-none">
    {#each list as record}
    <div class="flex flex-row bg-dark-200 py-1 cursor-pointer {activeName == record.name ? "active" : ""} hover"
      on:click={() => handleItemClick(record)}>
      <div class="w-1/2">
        <p>{record.name}</p>
      </div>
      <div class="w-1/2">
        <p>{record.cords}</p>
      </div>
    </div>
    {/each}
  </div>
  <div class="flex flex-row justify-between">
    <Button name={"Delete"} buttonClass="ml-5" on:click={() => handleDelete()}/>
    <Button name={"GOTO"} buttonClass="mr-5" on:click={() => handleGoto()}/>
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