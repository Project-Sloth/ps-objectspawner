<script lang="ts">
  import ObjectStore from '../../stores/objectStore';
  import NumberInput from '../../components/atoms/number-input.svelte';
  import Select from '../../components/atoms/select.svelte';
  import Button from '../../components/atoms/button.svelte';
</script>


<div class="flex flex-col gap-5 text-center">
  <div class="flex flex-col gap-1">
    <p>Select Object</p>
    <Select valuesArray={$ObjectStore.objectList} handleSelectFunction={(val) => ObjectStore.setObject(val)} virtualList/>
  </div>
  <div class="flex flex-col gap-1">
    <p>Render Distance</p>
    <NumberInput min={0} max={100} value={$ObjectStore.renderDistance} handleUpdateFunction={(val) => ObjectStore.setRenderDisable(val)}/>
  </div>
  <div class="flex flex-col gap-1">
    <p>Select Object Type</p>
    <Select valuesArray={$ObjectStore.objectTypes} handleSelectFunction={(val) => ObjectStore.setObjectType(val)}/>
  </div>
  <Button name={"Spawn Object"} buttonClass="mx-auto" on:click={ObjectStore.spawnObject}/>
</div>