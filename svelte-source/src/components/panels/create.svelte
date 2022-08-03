<script lang="ts">
  import ObjectStore from '../../stores/objectStore';
  import NumberInput from '../../components/atoms/number-input.svelte';
  import Select from '../../components/atoms/select.svelte';
  import Button from '../../components/atoms/button.svelte';
  import TextInput from '../../components/atoms/text-input.svelte';

  let { objectList, objectTypes } = ObjectStore;

  let currentName: string = "";
  let renderDistance: number = 100;
  let currentObject: string = "";
  let currentType: string = "";

  function handleSpawnObjectClick() {
    ObjectStore.spawnObject({
      name: currentName, object: currentObject, type: currentType, distance: renderDistance
    });
    currentName = "";
    renderDistance = 100;
    currentObject = "";
    currentType = "";
  }


</script>


<div class="flex flex-col gap-5 text-center mx-25">
  <div class="flex flex-col gap-1">
    <p class="text-xl font-bold">Name</p>
    <TextInput bind:value={currentName} placeholder="Object Name" maxLength={25}/>
  </div>
  <div class="flex flex-col gap-1">
    <p class="text-xl font-bold">Select Object</p>
    <Select valuesArray={$objectList} handleSelectFunction={(val) => currentObject = val} virtualList/>
  </div>
  <div class="flex flex-col gap-1">
    <p class="text-xl font-bold">Render Distance</p>
    <NumberInput min={0} max={500} bind:value={renderDistance}/>
  </div>
  <div class="flex flex-col gap-1">
    <p class="text-xl font-bold">Select Object Type</p>
    <Select valuesArray={$objectTypes} handleSelectFunction={(val) => currentType = val}/>
  </div>
  <Button name={"Spawn Object"} buttonClass="mx-auto" on:click={handleSpawnObjectClick}/>
</div>