import Debug from 'debug'
import {
  getDnsNamesWeight, getLoadBalancerZoneId,
  getSimpleServiceDockerTag,
  updateDnsNameKeyPrefix, updateDnsNamesWeight,
  updateLoadBalancerZoneId, updateSimpleServiceDockerTag
} from "../operations/state-management"
import { Route53DomainName, Route53HostedZoneId } from '../operations/config'
import { modifyRoute53Records } from "../operations/route-53"

const debug = Debug('op:get-docker-tag-assignments')

export const handler = async (event, context) => {
  const eventBody = JSON.parse(event.body)
  const { loadbalancers, newDockerTag } = eventBody
  const loadbalancersDns = loadbalancers.map(loadbalancer => loadbalancer.dns)

  await updateDnsNameKeyPrefix(loadbalancersDns)

  const [dns0, dns1] = loadbalancersDns
  const defaultWeight = {
    [dns0]: 100,
    [dns1]: 0
  }

  await Promise.all(
    loadbalancers.map(async ({ dns, zoneId }) => {
      debug(`Processing ${JSON.stringify({ dns, zoneId, newDockerTag })}`)
      await updateLoadBalancerZoneId(dns)(zoneId)
      const dockerTag = await getSimpleServiceDockerTag(dns)
      if (dockerTag === null) {
        await updateSimpleServiceDockerTag(dns)(newDockerTag)
      }

      const dnsWeight = await getDnsNamesWeight(dns)
      if (dnsWeight === null) {
        await updateDnsNamesWeight(dns)(defaultWeight[dns])
      }
    })
  )

  const actualWeight = {
    [dns0]: await getDnsNamesWeight(dns0),
    [dns1]: await getDnsNamesWeight(dns1)
  }

  const getInfo = async dns => ({
    aliasDnsName: dns,
    aliasZoneId: await getLoadBalancerZoneId(dns),
    weight: actualWeight[dns]
  })

  await modifyRoute53Records(
    Route53HostedZoneId,
    Route53DomainName,
    await getInfo(dns0),
    await getInfo(dns1)
  )

  const dnsWithTraffic = actualWeight[dns0] > actualWeight[dns1]?
    dns0 :
    dns1

  debug(`Updating ${dnsWithTraffic} with docker tag ${newDockerTag}`)
  await updateSimpleServiceDockerTag(dnsWithTraffic)(newDockerTag)

  const assignments = {
    [dns0]: await getSimpleServiceDockerTag(dns0),
    [dns1]: await getSimpleServiceDockerTag(dns1)
  }

  debug('Docker tag assignments', assignments)

  return {
    statusCode: 200,
    body: JSON.stringify({
      assignments
    }),
  };
}


// handler({
//   body: JSON.stringify({
//     loadbalancers: [{
//       dns: 'dns1.com',
//       zoneId: 'zoneId1'
//     }, {
//       dns: 'dns2.com',
//       zoneId: 'zoneId2'
//     }],
//     newDockerTag: 'latest'
//   })
// })
