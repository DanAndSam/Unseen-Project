using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Animator animator;

    private void Awake()
    {
        animator = GetComponentInChildren<Animator>();
        CombatManager.Instance.SetPlayerReference(this);
    }

    public void Attack()
    {
        if (animator != null)
        {
            StartCoroutine(TestReticule());
        }
    }

    public IEnumerator TestReticule()
    {
        //Just for testing purposes
        animator.SetTrigger("Step1");
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();

        yield return new WaitForSeconds(ReturnCurrentClipLength());

        animator.SetTrigger("Step2");
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();
        

        yield return new WaitForSeconds(ReturnCurrentClipLength());

        animator.SetTrigger("Step3");
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();
        

        yield return new WaitForSeconds(ReturnCurrentClipLength());

        animator.SetTrigger("Step4");
        yield return new WaitForEndOfFrame();
        CombatManager.Instance.LaunchReticule();
        
        yield return new WaitForSeconds(ReturnCurrentClipLength());
    }

    public float ReturnCurrentClipLength()
    {
        return animator.GetCurrentAnimatorStateInfo(0).length;
    }
}
