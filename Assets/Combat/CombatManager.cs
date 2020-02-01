using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CombatManager : MonoBehaviour
{
    public static CombatManager _instance;
    public static CombatManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = GameObject.FindObjectOfType<CombatManager>();

                if (_instance == null)
                {
                    GameObject container = new GameObject("Bicycle");
                    _instance = container.AddComponent<CombatManager>();
                }
            }

            return _instance;
        }
    }

    public AimingReticulis reticuleRef;

    public void InitCombat()
    {
        //Open Combat Interface
    }

    public void LaunchReticule()
    {
        reticuleRef.Launch();
    }
}

