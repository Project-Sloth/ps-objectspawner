<script lang="ts">
  export let name: string = "";
  export let active: boolean = false;

  let hover: boolean = false;
</script>

<div class="cursor-pointer w-25 bg-[#292929] rounded-lg p-[0.35rem] px-2 text-center"
  on:click on:pointerenter={()=>{hover=true}} on:pointerleave={()=>{hover=false}}>
  <p class="font-bold text-xl pb-1 {active ? "border-b-3 !border-[var(--ps-primary)]"
  :"hover:border-[var(--ps-primary-hover)] hover:border-b-3"} {hover ? "border-[var(--ps-primary-hover)] border-b-3":""}">
    {name}
  </p>
</div>